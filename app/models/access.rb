class Access < ActiveRecord::Base
  self.table_name = 'accesses'
  unloadable
  #include Redmine::SafeAttributes

  #acts_as_customizable
  #acts_as_activity_provider type: 'accesses',
  #                         author_key: :author_id,
  #                         timestamp: :created_at,
  #                         scope: joins(:project, :domain)

  attr_protected :id
  belongs_to :domain
  has_one :project, through: :domain
end
