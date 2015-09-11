class AddAccessCategory < ActiveRecord::Migration
  class << self
    def up
      drop_table :domains_settings
      remove_column :accesses, :name
      remove_column :accesses, :key
      add_column :accesses, :category_id, :integer
    end

    def down
      create_table :domains_settings do |t|
        t.string :name
        t.text :value
        t.integer :project_id
        t.datetime :updated_at
      end
      add_index :domains_settings, :project_id
      add_column :accesses, :name, :string
      add_column :accesses, :key, :string
      remove_column :accesses, :category_id
    end
  end
end
