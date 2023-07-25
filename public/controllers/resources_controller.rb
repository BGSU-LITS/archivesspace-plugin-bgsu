ResourcesController
class ResourcesController
  helper_method :process_digital_instance

  def show
    uri = "/repositories/#{params[:rid]}/resources/#{params[:id]}"
    begin
      @criteria = {}
      @criteria['resolve[]'] = ['repository:id', 'resource:id@compact_resource', 'top_container_uri_u_sstr:id', 'related_accession_uris:id', 'digital_object_uris:id']

      tree_root = archivesspace.get_raw_record(uri + '/tree/root') rescue nil
      @has_children = tree_root && tree_root['child_count'] > 0
      @has_containers = has_containers?(uri)

      @result =  archivesspace.get_record(uri, @criteria)
      @repo_info = @result.repository_information
      @page_title = "#{I18n.t('resource._singular')}: #{strip_mixed_content(@result.display_string)}"
      @context = [
        {:uri => @repo_info['top']['uri'], :crumb => @repo_info['top']['name'], :type => 'repository'},
        {:uri => nil, :crumb => process_mixed_content(@result.display_string), :type => 'resource'}
      ]
#      @rep_image = get_rep_image(@result['json']['instances'])
      fill_request_info
      @ordered_records = archivesspace.get_record(uri + '/ordered_records').json.fetch('uris')
    rescue RecordNotFound
      record_not_found(uri, 'resource')
    end
  end

  def infinite
    @root_uri = "/repositories/#{params[:rid]}/resources/#{params[:id]}"
    begin
      @criteria = {}
      @criteria['resolve[]'] = ['repository:id', 'resource:id@compact_resource', 'top_container_uri_u_sstr:id', 'related_accession_uris:id']
      @result = archivesspace.get_record(@root_uri, @criteria)
      @has_containers = has_containers?(@root_uri)

      @repo_info = @result.repository_information
      @page_title = "#{I18n.t('resource._singular')}: #{strip_mixed_content(@result.display_string)}"
      @context = [{:uri => @repo_info['top']['uri'], :crumb => @repo_info['top']['name'], type: 'repository'},
        {:uri => nil, :crumb => process_mixed_content(@result.display_string), type: @result.primary_type}]
      fill_request_info
      @ordered_records = archivesspace.get_record(@root_uri + '/ordered_records').json.fetch('uris')
      @paging = {}
      @paging['per_page'] = 1000
      @paging['total_hits'] = @ordered_records.length
      @paging['last_page'] = @paging['total_hits'].div(@paging['per_page']) + 1
      @paging['this_page'] = Integer(params.fetch(:page, "1")).clamp(1, @paging['last_page'])
      @paging['offset_first'] = @paging['per_page'] * (@paging['this_page'] - 1) + 1
      @paging['offset_last'] = (@paging['per_page'] * @paging['this_page']).clamp(1, @paging['total_hits'])
      @results = archivesspace.search_records(
        @ordered_records.map { |record| record['ref'] }.slice(
          @paging['per_page'] * (@paging['this_page'] - 1),
          @paging['per_page']
        ),
        { 'resolve[]' => ['top_container_uri_u_sstr:id'] },
        true
      )
      @dig_objs = {}
      @results.records.each do |record|
        @dig_objs[record.uri] = process_digital_instance(record['json']['instances'])
      end
      @pager = Pager.new(
        @root_uri + '/collection_organization',
        @paging['this_page'],
        @paging['last_page']
      )
    rescue RecordNotFound
      record_not_found(@root_uri, 'resource')
    end
  end
end
