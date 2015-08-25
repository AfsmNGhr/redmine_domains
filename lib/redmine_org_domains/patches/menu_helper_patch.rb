module RedmineOrgDomains::Patches::MenuHelperPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end
end
