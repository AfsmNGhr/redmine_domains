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
    end
  end

  def self.down
    drop_table :domains
  end
end
