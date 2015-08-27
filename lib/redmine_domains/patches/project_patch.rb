require_dependency 'project'

class Project
  unloadable
  has_many :domains, dependent: :destroy
  has_many :accesses, through: :domains
end
