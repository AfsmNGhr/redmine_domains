class AddHostDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :hosting, :boolean, default: false
  end

  def self.down
    remove_column :domains, :hosting
  end
end
