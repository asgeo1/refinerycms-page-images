require 'refinerycms-core'

module Refinery
  autoload :PageResourcesGenerator, 'generators/refinery/page_resources_generator'

  module PageResources

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end

      def attach!
        require 'refinery/page'
        require 'refinery/page_resources/extension'

        config.enabled_models.each do |model_class_name|
          unless (model_class = model_class_name.safe_constantize)
            Rails.logger.warn "PageResources is unable to find model class: #{model_class_name}"
            next
          end
          model_class.send :has_many_page_resources
        end

        Refinery::Resource.send :has_many, :resource_pages, :dependent => :destroy

        # dosnt work wothout this...
        require root.join('app/decorators/controllers/refinery/admin/pages_controller_decorator.rb')

      end
    end

    require 'refinery/page_resources/engine'
  end
end
