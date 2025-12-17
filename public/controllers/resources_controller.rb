ResourcesController
class ResourcesController
  helper_method :process_digital_instance

  DEFAULT_RES_FACET_TYPES = %w{primary_type subjects published_agents langcode classification_paths}

  def waypoints
    search_opts = {
      'resolve[]' => ['top_container_uri_u_sstr:id']
    }
    results = archivesspace.search_records(params[:urls], search_opts, true)

    render :json => Hash[results.records.map {|record|
                           @result = record
                           @dig = process_digital_instance(record['json']['instances'])
                           [record.uri,
                            render_to_string(:partial => 'infinite_item')]}]
  end 
end
