module Refinery
  class PageResourcesGenerator < Rails::Generators::Base

    source_root File.expand_path("../templates", __FILE__)

    def rake_db
      rake("refinery_page_resources:install:migrations")
    end

    def generate_page_resources_initializer
      template "config/initializers/refinery/page_resources.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "page_resources.rb")
    end

  end
end
