Refinery::Admin::PagesController.class_eval do

  # # We need to add :resources_attributes to page_params as it is ignored by strong parameters. (See #100)
  # def page_params_with_page_resource_params

  #   # Get the :resources_attributes hash from params
  #   page_resource_params = params.require(:page).permit(resources_attributes: [:id, :caption])

  #   # If there is no :resources_attributes hash use a blank hash (so it removes deleted resources)
  #   page_resource_params = {resources_attributes:{}} if page_resource_params[:resources_attributes].nil?

  #   # Add the :resources_attributes hash to the default page_params hash
  #   page_params_without_page_resource_params.merge(page_resource_params)

  # end

  # # Swap out the default page_params method with our new one
  # alias_method_chain :page_params, :page_resource_params

  pp_method_builder = Proc.new do
    # Get a reference to the  original method with all previous permissions already applied.
    page_params_method = instance_method :page_params

    # Define the new method.
    define_method("page_params_with_page_resource_params") do
      pi_params = params.require(:page).permit(resources_attributes: [:id, :caption, :resource_page_id])
      page_params_method.bind(self).call().merge(pi_params)
    end
  end

  alias_method_chain :page_params, :page_resource_params, &pp_method_builder

end
