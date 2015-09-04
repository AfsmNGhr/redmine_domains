class Access < ActiveRecord::Base
  self.table_name = 'accesses'
  unloadable
  include Redmine::SafeAttributes

  safe_attributes 'name', 'key', 'domain_id',
                  'url', 'login', 'password',
                  'description'
  attr_protected :id

  belongs_to :domain
  has_one :project, through: :domain
end
