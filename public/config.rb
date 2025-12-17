# Disable language selection.
AppConfig[:allow_pui_language_selection] = false

# Disable user registration.
AppConfig[:allow_user_registration] = false

# Increase number of results per page in staff interface.
AppConfig[:default_page_size] = 50

# Do not block referrer.
AppConfig[:pui_block_referrer] = false

# Expand all expandable notes by default.
AppConfig[:pui_expand_all] = true

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

AppConfig[:pui_repos]['bpcl'] = {}
AppConfig[:pui_repos]['bpcl'][:hide] = {}
AppConfig[:pui_repos]['bpcl'][:hide][:classification_badge] = false

# Reduce the number of characters before having a 'Read More' button.
AppConfig[:pui_readmore_max_characters] = 250

# Always show search form in collections.
AppConfig[:pui_search_collection_from_archival_objects] = true
AppConfig[:pui_search_collection_from_collection_organization] = true

# Increase number of results per page.
AppConfig[:pui_search_results_page_size] = 25

# Do not use default favicon.
AppConfig[:pui_show_favicon] = false

