# coding: utf-8
require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_domains/patches/project_patch'
  require_dependency 'redmine_domains/patches/enumeration_patch'
  require_dependency 'redmine_domains/patches/custom_field_helper_patch'
  ActionView::Base.send(:include, DomainsHelper, AccessesHelper)
end

Redmine::Plugin.register :redmine_domains do
  name 'Redmine Domains'
  author 'Ermolaev Alexsey'
  description 'Add domains and their accesses for projects'
  author_url 'afay.zangetsu@gmail.com'
  version '0.6'
  requires_redmine version_or_higher: '3.0.0'

  project_module :accesses do
    permission :view_accesses, { accesses: [:index, :show] }
    permission :add_accesses, { accesses: [:new, :create] }
    permission :edit_accesses, { accesses: [:edit, :update] }
    permission :manage_accesses, { projects: :settings,
                                   accesses_settings: :save }
    permission :view_domains, { domains: [:index, :show] }
    permission :add_domains, { domains: [:new, :create] }
    permission :edit_domains, { domains: [:edit, :update] }
  end

  menu :project_menu, :accesses, { controller: 'accesses', action: 'index'},
       caption: :label_access_plural, html: { 'data-remote' => 'true' }

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
