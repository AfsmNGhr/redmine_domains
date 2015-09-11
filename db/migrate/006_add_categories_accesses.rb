# coding: utf-8
class AddCategoriesAccesses < ActiveRecord::Migration
  class << self
    def up
      categories = [{ name: 'Админка CMS', is_default: true },
                    { name: 'Админка хоста', is_default: false },
                    { name: 'FTP', is_default: false },
                    { name: 'SSH', is_default: false },
                    { name: 'Mysql', is_default: false },
                    { name: 'Live Internet', is_default: false }]

      categories.each do |category|
        AccessCategory.new(
          name: category[:name],
          is_default: category[:is_default],
          active: true,
          position: categories.index(category)
        ).save
      end
    end

    def down
      AccessCategory.delete_all
    end
  end
end
