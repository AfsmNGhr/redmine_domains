class Domain < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  acts_as_customizable
  acts_as_activity_provider type: 'domains',
                            author_key: :author_id,
                            timestamp: :created_at,
                            scope: joins(:project)

  acts_as_searchable columns: ["#{table_name}.name",
                               "#{table_name}.status",
                               "#{Access.table_name}.category",
                               "#{Access.table_name}.url",
                               "#{Access.table_name}.login",
                               "#{Access.table_name}.password",
                               "#{Access.table_name}.description"],
                     scope: includes(:project, :accesses),
                     project_key: "#{Project.table_name}.id",
                     date_column: 'created_at'

  acts_as_event datetime: :created_at,
                title: Proc.new {|d| "#{l(:label_domain)}: #{d.name}"},
                url: Proc.new {|d| { controller: 'domains',
                                     action: 'show', id: d}},
                description: lambda { |d| [d.name, d.project, d.status,
                                           d.accesses.includes(:category).
                                             map(&:category).join(', '),
                                           d.ending_date].join(' ') }

  safe_attributes 'name', 'status', 'accesses', 'hidden', 'checked',
                  'author_id', 'ending_date', 'hosting', 'visibility',
                  'project_id', 'custom_field_values', 'custom_fields'
  attr_protected :id
  validates_presence_of :name, :project_id
  belongs_to :project
  has_many :accesses, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  scope :visible, lambda { |*args|
    joins(:project).where(Domain.visible_condition(args.shift || User.current, *args)) }

  scope :hidden, lambda { where(hidden: true) }
  scope :domains, lambda { where(hosting: false) }
  scope :hostings, lambda { where(hosting: true) }
  scope :month, lambda { where("ending_date BETWEEN ? AND ?",
                               Date.today.at_beginning_of_month,
                               (Date.today + 1.months).at_beginning_of_month) }

  def self.table(params)
    scope = if params[:hosting] == '1'
              self.visible.hostings
            else
              self.visible.domains
            end
    if params[:hidden] == '1'
      if params[:hostings] == '1'
        scope.hidden
      else
        scope.hidden
      end
    elsif params[:month] == '1'
      scope.month
    else
      scope
    end
  end

  def self.visible_condition(user, options={})
    user.reload
    user_ids = [user.id] + user.groups.map(&:id)

    projects_allowed_to_view_domains =
      Project.where(Project.allowed_to_condition(user, :view_domains)).pluck(:id)

    allowed_to_view_condition =
      projects_allowed_to_view_domains.empty? ? "(1=0)" :
        "#{Project.table_name}.id IN (#{projects_allowed_to_view_domains.join(',')})"

    projects_allowed_to_view_private =
      Project.where(Project.allowed_to_condition(user, :view_private_domains)).pluck(:id)

    allowed_to_view_private_condition =
      projects_allowed_to_view_private.empty? ? "(1=0)" :
        "#{Project.table_name}.id IN (#{projects_allowed_to_view_private.join(',')})"

    cond = "(#{Project.table_name}.id <> -1 ) AND ("
    if user.admin?
      cond << "(#{table_name}.visibility = 1) OR (#{allowed_to_view_condition}) "
    else
      cond << " (#{table_name}.visibility = 1) OR" if user.allowed_to_globally?(:view_domains, {})
      cond << " (#{allowed_to_view_condition} AND #{table_name}.visibility <> 2) "

      if user.logged?
        cond << " OR (#{allowed_to_view_private_condition} " +
                " OR (#{allowed_to_view_condition} " +
                " AND (#{table_name}.author_id = #{user.id} )))"
      end
    end

    cond << ")"
  end
end
