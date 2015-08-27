require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_org_domains/patches/project_patch'
  require_dependency 'redmine_org_domains/patches/custom_field_helper_patch'
  require_dependency 'redmine_org_domains/patches/application_helper_patch'
  ActionView::Base.send(:include, DomainsHelper)
end

Redmine::Plugin.register :redmine_org_domains do
  name 'Redmine Org Domains'
  author 'Ermolaev Alexsey'
  description 'Add domains for projects'
  author_url 'mailto:afay.zangetsu@gmail.com'
  version '0.3'
  requires_redmine version_or_higher: '3.0.0'

  menu :top_menu, :domains, { controller: 'domains', action: 'index' },
       caption: :label_domain_plural

  menu :domain_menu, :default, { controller: 'domains', action: 'index',
                                 params: { hosting: '0' } },
       html: { 'data-remote' => 'true', class: 'is-active' },
       caption: :label_domain_plural, first: true

  menu :domain_menu, :hosting, { controller: 'domains', action: 'index',
                                 params: { hosting: '1' } },
       html: { 'data-remote' => 'true' },
       caption: :label_hosting_plural

  activity_provider :domains, default: false, class_name: ['Domain']

  Redmine::Search.map do |search|
    search.register :domains
  end
end
