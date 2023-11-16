AccessionsController
class AccessionsController
  helper_method :process_digital_instance

  def show
    uri = "/repositories/#{params[:rid]}/accessions/#{params[:id]}"
    @criteria = {}
    @criteria['resolve[]'] = ['repository:id', 'resource:id@compact_resource', 'related_resource_uris:id', 'related_accession_uris:id', 'top_container_uri_u_sstr:id', 'digital_object_uris:id']
    begin
      @result = archivesspace.get_record(uri, @criteria)
      @page_title = @result.display_string
      @context = []
      @context.unshift({
        :uri => @result.resolved_repository['uri'],
        :crumb => @result.resolved_repository['name'],
        :type => 'repository'
      })
      @context.push({
        :uri => '',
        :crumb => @result.display_string,
        :type => 'accession'
      })
      fill_request_info
      @dig = process_digital_instance(@result['json']['instances'])
    rescue RecordNotFound
      record_not_found(uri, 'accession')
    end
  end
end
