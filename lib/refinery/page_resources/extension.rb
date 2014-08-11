module Refinery
  module PageResources
    module Extension
      def has_many_page_resources
        has_many :resource_pages, proc { order('position ASC') }, :as => :page, :class_name => 'Refinery::ResourcePage'
        has_many :resources, proc { order('position ASC') }, :through => :resource_pages, :class_name => 'Refinery::Resource'
        # accepts_nested_attributes_for MUST come before def resources_attributes=
        # this is because resources_attributes= overrides accepts_nested_attributes_for.

        accepts_nested_attributes_for :resources, :allow_destroy => false

        # need to do it this way because of the way accepts_nested_attributes_for
        # deletes an already defined resources_attributes
        module_eval do
          def resources_attributes=(data)
            data = data.reject {|_, data| data.blank?}
            ids_to_keep = data.map{|_, d| d['resource_page_id']}.compact

            resource_pages_to_delete = if ids_to_keep.empty?
              self.resource_pages
            else
              self.resource_pages.where.not(:id => ids_to_keep)
            end

            resource_pages_to_delete.destroy_all

            data.each do |i, resource_data|
              resource_page_id, resource_id, caption =
                resource_data.values_at('resource_page_id', 'id', 'caption')

              next if resource_id.blank?

              resource_page = if resource_page_id.present?
                self.resource_pages.find(resource_page_id)
              else
                self.resource_pages.build(:resource_id => resource_id)
              end

              resource_page.position = i
              resource_page.caption = caption if Refinery::PageResources.captions
              resource_page.save
            end
          end
        end

        include Refinery::PageResources::Extension::InstanceMethods
      end

      module InstanceMethods

        def caption_for_resource_index(index)
          self.resource_pages[index].try(:caption).presence || ""
        end

        def resource_page_id_for_resource_index(index)
          self.resource_pages[index].try(:id)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Refinery::PageResources::Extension)
