require_dependency 'project'

class Project
  unloadable
  has_and_belongs_to_many :domains, dependent: :delete_all
end
