class CreatePageResources < ActiveRecord::Migration
  def change
    create_table Refinery::ResourcePage.table_name, :id => false do |t|
      t.integer :resource_id
      t.integer :page_id
      t.integer :position
    end

    add_index Refinery::ResourcePage.table_name, :resource_id
    add_index Refinery::ResourcePage.table_name, :page_id
  end
end
