class AccessCategory < Enumeration
  has_many :accesses, foreign_key: 'category_id'

  OptionName = :enumeration_access_categories

  def option_name
    OptionName
  end

  def objects_count
    accesses.count
  end

  def transfer_relations(to)
    accesses.update_all(category_id: to.id)
  end

  def self.default
    d = super
    d = first if d.nil?
    d
  end
end
