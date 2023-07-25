require File.join(File.dirname(__FILE__), "config.rb")

Rails.application.config.after_initialize do
  ['objects', 'resources'].each {
    |type|
    require File.join(
      File.dirname(__FILE__),
      "controllers",
      "#{type}_controller.rb"
    )
  }
end
