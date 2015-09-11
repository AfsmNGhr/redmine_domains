class Access < ActiveRecord::Base
  unloadable
  self.table_name = 'accesses'
  include Redmine::SafeAttributes

  safe_attributes 'category_id', 'domain_id',
                  'url', 'login', 'password',
                  'description'
  attr_protected :id

  belongs_to :domain
  has_one :project, through: :domain
  belongs_to :category, class_name: 'AccessCategory'

  def initialize(attributes = nil, *args)
    super
    self.category ||= AccessCategory.default if new_record?
  end

  def visible?(user = User.current)
    !user.nil? && user.allowed_to?(:view_accesses, project)
  end
end
