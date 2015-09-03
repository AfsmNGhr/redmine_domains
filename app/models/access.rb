class Access < ActiveRecord::Base
  self.table_name = 'accesses'
  unloadable

  attr_protected :id
  belongs_to :domain
  has_one :project, through: :domain
end
