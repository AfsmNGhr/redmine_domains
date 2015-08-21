require_dependency 'project'

class Project
  unloadable
  has_many :domains, dependent: :delete_all
end
