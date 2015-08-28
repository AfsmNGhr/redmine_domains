class DomainsSetting < ActiveRecord::Base
  unloadable

  belongs_to :project
  attr_accessible :name, :value, :project_id
  cattr_accessor :settings
  validates_uniqueness_of :name, scope: [ :project_id ]

  @domains_cached_settings = {}
  @domains_cached_cleared_at = Time.now

  # Returns the value of the setting named name
  def self.[](name, project_id)
    project_id = project_id.id if project_id.is_a?(Project)
    v = @domains_cached_settings[hk(name, project_id)]
    v ? v : (@domains_cached_settings[hk(name, project_id)] = find_or_default(name, project_id).value)
  end

  def self.[]=(name, project_id, v)
    project_id = project_id.id if project_id.is_a?(Project)
    setting = find_or_default(name, project_id)
    setting.value = (v ? v : "")
    @domains_cached_settings[hk(name, project_id)] = nil
    setting.save
    setting.value
  end

  # Checks if settings have changed since the values were read
  # and clears the cache hash if it's the case
  # Called once per request
  def self.check_cache
    settings_updated_at = DomainsSetting.maximum(:updated_at)
    if settings_updated_at && @domains_cached_cleared_at <= settings_updated_at
      clear_cache
    end
  end

  # Clears the settings cache
  def self.clear_cache
    @domains_cached_settings.clear
    @domains_cached_cleared_at = Time.now
    logger.info "Accesses settings cache cleared." if logger
  end

  def self.accesses
    self.accesses_keys.zip(self.accesses_names).to_h
  end

  def self.accesses_names
    Setting.plugin_redmine_domains[:accesses_names].
      to_s.split(', ').select{ |n| !n.blank? }.map(&:strip)
  end

  def self.accesses_keys
    Setting.plugin_redmine_domains[:accesses_keys].
      to_s.split(', ').select{ |k| !k.blank? }.map(&:strip)
  end

  private

  def self.hk(name, project_id)
    "#{name}-#{project_id.to_s}"
  end

  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name, project_id)
    name = name.to_s
    setting = find_by_name_and_project_id(name, project_id)
    setting ||= new(name: name, value: '', project_id: project_id)
  end
end
