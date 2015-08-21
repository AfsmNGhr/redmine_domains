module DomainsHelper
  def hide_or_show_link(domain)
    icon, id, label =
              if domain.hidden?
                ['backup', "domain-show-#{domain.id}", l(:label_domain_show)]
              else
                ['archive', "domain-hide-#{domain.id}", l(:label_domain_hide)]
              end
    link_to (content_tag(:i, icon, class: 'material-icons', id: id) +
             (content_tag(:span, label, class: 'mdl-tooltip', for: id))),
            hide_or_show_domain_path(domain), remote: true
  end
end
