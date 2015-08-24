class AddDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name
      t.string :status
      t.date :ending_date
      t.text :accesses
      t.boolean :hidden, default: false
      t.boolean :checked, default: false
      t.integer :project_id
      t.integer :author_id
      t.datetime :created_at
      t.datetime :update_at
    end
  end

  def self.down
    drop_table :domains
  end
end
