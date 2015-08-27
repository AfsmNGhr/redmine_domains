class CreateDomainsSettings < ActiveRecord::Migration
  def self.up
    create_table :domains_settings do |t|
      t.string :name
      t.text :value
      t.integer :project_id
      t.datetime :updated_at
    end
    add_index :domains_settings, :project_id
  end

  def self.down
    drop_table :domains_settings
  end
end
