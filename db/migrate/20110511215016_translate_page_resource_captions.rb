class TranslatePageResourceCaptions < ActiveRecord::Migration
  def up
    add_column Refinery::ResourcePage.table_name, :id, :primary_key

    Refinery::ResourcePage.reset_column_information
    unless defined?(Refinery::ResourcePage::Translation) && Refinery::ResourcePage::Translation.table_exists?
      Refinery::ResourcePage.create_translation_table!({
        :caption => :text
      }, {
        :migrate_data => true
      })
    end
  end

  def down
    Refinery::ResourcePage.reset_column_information

    Refinery::ResourcePage.drop_translation_table! :migrate_data => true

    remove_column Refinery::ResourcePage.table_name, :id
  end
end
