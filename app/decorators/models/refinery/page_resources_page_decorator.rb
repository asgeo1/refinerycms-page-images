Refinery::Page.class_eval do
  attr_accessor :resources_with_captions

  def resources_with_captions
    @resources_with_captions = resource_pages.map do |ref|
      {
        resource: Refinery::Resource.find(ref.resource_id),
        caption: ref.caption || ''
      }
    end
  end
end

