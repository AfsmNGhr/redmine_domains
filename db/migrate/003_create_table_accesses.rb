class CreateTableAccesses < ActiveRecord::Migration
  def self.up
    create_table :accesses do |t|
      t.string :key
      t.string :name
      t.string :url
      t.string :login
      t.string :password
      t.text :description
      t.integer :domain_id
      t.timestamp :created_at
      t.timestamp :updated_at
    end
    remove_column :domains, :accesses rescue nil
  end

  def self.down
    drop_table :accesses
  end
end
