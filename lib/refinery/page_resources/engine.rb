require 'refinery/page_resources/configuration'

module Refinery
  module PageResources
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery

      engine_name :refinery_page_resources

      def self.register(tab)
        tab.name = ::I18n.t(:'refinery.plugins.refinery_page_resources.tab_name')
        tab.partial = "/refinery/admin/pages/tabs/resources"
      end

      def self.initialize_tabs!
        PageResources.config.enabled_tabs.each do |tab_class_name|
          unless (tab_class = tab_class_name.safe_constantize)
            Rails.logger.warn "PageResources is unable to find tab class: #{tab_class_name}"
            next
          end
          tab_class.register { |tab| register tab }
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = 'page_resources'
          plugin.pathname = root
          plugin.hide_from_menu = true
        end
      end

      config.to_prepare do
        Refinery::PageResources.attach!
      end

      config.after_initialize do
        initialize_tabs!
        Refinery.register_engine Refinery::PageResources
      end
    end
  end
end
