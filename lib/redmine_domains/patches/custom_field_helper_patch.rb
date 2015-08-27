require_dependency 'custom_fields_helper'

module CustomFieldsHelper
  CUSTOM_FIELDS_TABS << { name: 'DomainCustomField',
                          partial: 'custom_fields/index',
                          label: :label_domain_plural }
end
