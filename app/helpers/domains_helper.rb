module DomainsHelper
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
end
