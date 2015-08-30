module DomainsHelper
  def settings_domains_tabs
    [ { name: 'accesses', partial: 'settings/domains/accesses',
        label: :label_access_plural } ]
  end

  def hide_or_show_link(domain)
    icon, id, label =
              if domain.hidden
                ['backup', "domain-show-#{domain.id}",
                 domain.hosting ? l(:label_hosting_show) : l(:label_domain_show)]
              else
                ['archive', "domain-hide-#{domain.id}",
                 domain.hosting ? l(:label_hosting_hide) : l(:label_domain_hide)]
              end
    link_to (content_tag(:i, icon, class: 'material-icons', id: id) +
             (content_tag(:span, label, class: 'mdl-tooltip', for: id))),
            hide_or_show_domain_path(domain)
  end

  def domain_title(domain)
    if domain.hosting
      domain.hidden? ? l(:label_hosting_hidden) : l(:label_hosting)
    else
      domain.hidden? ? l(:label_domain_hidden) : l(:label_domain)
    end
  end

  def statuses
    [ l(:domain_service),
      l(:domain_self_service),
      l(:domain_not_access) ]
  end

  def is_domains_show?
    route =
      Rails.application.routes.recognize_path(URI(request.referer).path)
    if route[:controller] == 'domains' && route[:action] == 'show'
      true
    else
      false
    end
  end
end
