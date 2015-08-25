class Domain < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  STATUSES = [
    l(:domain_service),
    l(:domain_self_service),
    l(:domain_not_access) ]

  acts_as_customizable
  acts_as_activity_provider type: 'domains',
                            author_key: :author_id

  acts_as_searchable columns: ['#{table_name}.name',
                               "#{table_name}.status",
                               "#{table_name}.accesses",
                               "#{table_name}.ending_date"],
                     project_key: "#{Project.table_name}.id",
                     date_column: 'created_at'

  acts_as_event datetime: :created_at,
                title: Proc.new {|d| "#{l(:label_domain)}: #{d.name}"},
                url: Proc.new {|d| { controller: 'domains',
                                     action: 'show', id: d}},
                description: lambda {|d| [d.name, d.project, d.status,
                                          d.accesses, d.ending_date].
                                      join(' ')}

  safe_attributes 'name', 'status', 'ending_date', 'accesses',
                  'hidden', 'checked', 'author_id', 'project_id',
                  'custom_field_values', 'custom_fields'
  attr_protected :id
  validates_presence_of :name
  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  scope :visible, lambda { where(hidden: false) }
  scope :hidden, lambda { where(hidden: true) }
  scope :month, lambda { where("MONTH(`ending_date`) = MONTH(NOW())") }

  def self.table(params)
    if params[:hidden] == '1'
      params[:month].eql?('1') ? self.hidden.month : self.hidden
    else
      params[:month].eql?('1') ? self.visible.month : self.visible
    end
  end
end
