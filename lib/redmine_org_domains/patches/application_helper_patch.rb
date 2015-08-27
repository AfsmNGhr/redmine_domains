require_dependency 'application_helper'

module RedmineOrgDomains::Patches::ApplicationHelperPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :calendar_for, :ajax
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def calendar_for_with_ajax(field_id)
      include_calendar_headers_tags
      javascript_tag("$(function() { $('##{field_id}').datepicker(typeof(datepickerOptions)!='undefined'? datepickerOptions: {}); });")
    end
  end
end

ApplicationHelper.
  send :include, RedmineOrgDomains::Patches::ApplicationHelperPatch
