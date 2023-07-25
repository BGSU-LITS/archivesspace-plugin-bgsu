# Disable user registration.
AppConfig[:allow_user_registration] = false

# Increase number of results per page in staff interface.
AppConfig[:default_page_size] = 50

# Disable help, as it is only available with a membership.
AppConfig[:help_enabled] = false

# Do not block referrer.
AppConfig[:pui_block_referrer] = false

# Hide specific objects from Public UI.
AppConfig[:pui_hide][:digital_objects] = true
AppConfig[:pui_hide][:accessions] = true
AppConfig[:pui_hide][:classifications] = true
AppConfig[:pui_hide][:container_inventory] = true

AppConfig[:pui_hide][:digital_object_badge] = true
AppConfig[:pui_hide][:accession_badge] = true
AppConfig[:pui_hide][:classification_badge] = true

AppConfig[:pui_repos] = {}
AppConfig[:pui_repos]['cac'] = {}
AppConfig[:pui_repos]['cac'][:hide] = {}
AppConfig[:pui_repos]['cac'][:hide][:classification_badge] = false

# Always show search form in collections.
AppConfig[:pui_search_collection_from_archival_objects] = true
AppConfig[:pui_search_collection_from_collection_organization] = true

# Increase number of results per page.
AppConfig[:pui_search_results_page_size] = 25

# Hide inherited metadata in archival objects.
AppConfig[:record_inheritance] = {
  :archival_object => {
    :inherited_fields => [
      {
        :property => 'title',
        :skip_if => true,
        :inherit_directly => true
      },
      {
        :property => 'component_id',
        :skip_if => true,
        :inherit_directly => false
      },
      {
        :property => 'lang_materials',
        :skip_if => true,
        :inherit_directly => false
      },
      {
        :property => 'dates',
        :skip_if => true,
        :inherit_directly => true
      },
      {
        :property => 'extents',
        :skip_if => true,
        :inherit_directly => false
      },
      {
        :property => 'linked_agents',
        :skip_if => true,
        :inherit_if => proc {|json| json.select {|j| j['role'] == 'creator'} },
        :inherit_directly => false
      },
      {
        :property => 'notes',
        :skip_if => true,
        :inherit_if => proc {|json| json.select {|j| j['type'] == 'accessrestrict'} },
        :inherit_directly => true
      },
      {
        :property => 'notes',
        :skip_if => true,
        :inherit_if => proc {|json| json.select {|j| j['type'] == 'scopecontent'} },
        :inherit_directly => false
      },
      {
        :property => 'notes',
        :skip_if => true,
        :inherit_if => proc {|json| json.select {|j| j['type'] == 'langmaterial'} },
        :inherit_directly => false
      },
    ]
  }
}
