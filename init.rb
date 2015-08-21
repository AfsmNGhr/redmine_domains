require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_org_domains/patches/project_patch'
  require_dependency 'redmine_org_domains/patches/custom_field_helper_patch'
  ActionView::Base.send(:include, DomainsHelper)
end

Redmine::Plugin.register :redmine_org_domains do
  name 'Redmine Org Domains'
  author 'Ermolaev Alexsey'
  description 'Add domains for projects'
  author_url 'mailto:afay.zangetsu@gmail.com'
  version '0.1'
  requires_redmine version_or_higher: '3.0.0'

  menu :top_menu, :domains, { controller: 'domains', action: 'index' },
       caption: :label_domain_plural
end
