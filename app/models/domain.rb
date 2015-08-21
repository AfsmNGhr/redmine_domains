class Domain < ActiveRecord::Base
  include Redmine::SafeAttributes

  acts_as_customizable
  safe_attributes
  attr_accessible :name, :status, :ending_date, :checked,
                  :hidden, :accesses, :project_id,
                  :custom_field_values, :custom_fields

  validates_presence_of :name
  belongs_to :project
  scope :visible, lambda { where(hidden: false) }
  scope :hidden, lambda { where(hidden: true) }
  scope :month, lambda { where("MONTH(`ending_date`) = MONTH(NOW())") }

  STATUSES = [
    l(:domain_service),
    l(:domain_self_service),
    l(:domain_not_access) ]

  def self.table(params)
    if params[:hidden] == '1'
      params[:month].eql?('1') ? self.hidden.month : self.hidden
    else
      params[:month].eql?('1') ? self.visible.month : self.visible
    end
  end
end
