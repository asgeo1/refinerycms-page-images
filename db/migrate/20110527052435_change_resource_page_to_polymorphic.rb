class ChangePageToPolymorphic < ActiveRecord::Migration
  def change
    add_column Refinery::ResourcePage.table_name, :page_type, :string, :default => "page"
  end
end
