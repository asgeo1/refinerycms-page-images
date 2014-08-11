module Refinery
  class ResourcePage < Refinery::Core::BaseModel

    belongs_to :resource
    belongs_to :page, :polymorphic => true

    translates :caption if self.respond_to?(:translates)
  end
end
