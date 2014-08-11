class AddCaptionToResourcePages < ActiveRecord::Migration
  def change
    add_column Refinery::ResourcePage.table_name, :caption, :text
  end
end
