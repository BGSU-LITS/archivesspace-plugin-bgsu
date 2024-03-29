ObjectsController
class ObjectsController
  include PrefixHelper

  def show
    uri = "/repositories/#{params[:rid]}/#{params[:obj_type]}/#{params[:id]}"
    url = uri
    if params[:obj_type] == 'archival_objects'
      url = uri += '#pui' if !uri.ends_with?('#pui')
    end
    uri = uri.sub("\#pui", '')
    @criteria = {}
    @criteria['resolve[]'] = ['repository:id', 'resource:id@compact_resource', 'top_container_uri_u_sstr:id', 'linked_instance_uris:id', 'digital_object_uris:id']

    begin
      @result = archivesspace.get_record(url, @criteria)

      if params[:obj_type] == 'digital_object_components'
        redirect_to app_prefix(@result['json']['digital_object']['ref'])

        return
      end

      if params[:obj_type] == 'digital_objects'
        redirect_to app_prefix(@result['json']['linked_instances'][0]['ref'])

        return
      end

      if params[:obj_type] == 'archival_objects'
        @ordered_records = archivesspace.get_record(@result.root_node_uri + '/ordered_records').json.fetch('uris')

        page = (@ordered_records.map {|r| r['ref']}.index(@result.uri) / 500).floor() + 1

        redirect_to app_prefix(@result.root_node_uri + "/collection_organization") +
          (page > 1 ? "?page=#{page}" : "") + "#tree::archival_object_#{params[:id]}"

        return
      end

      if params[:obj_type] == 'digital_objects'
        tree_root = archivesspace.get_raw_record(uri + '/tree/root') rescue nil
        @has_children = tree_root && tree_root['child_count'] > 0
      end

      @repo_info =  @result.repository_information
      @page_title = @result.display_string
      @context = [
        {:uri => @repo_info['top']['uri'], :crumb => @repo_info['top']['name'], :type => 'repository'}
      ].concat(@result.breadcrumb)
      fill_request_info
      if @result['primary_type'] == 'digital_object' || @result['primary_type'] == 'digital_object_component'
        @dig = process_digital(@result['json'])
      else
        @dig = process_digital_instance(@result['json']['instances'])
        process_extents(@result['json'])
      end

      render
    rescue RecordNotFound
      type = "#{(params[:obj_type] == 'archival_objects' ? 'archival' : 'digital')}_object"
      record_not_found(uri, type)
    end
  end
end
