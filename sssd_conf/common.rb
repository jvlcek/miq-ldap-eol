module MiQLdapToSssd
  class SssdConfCommon
    attr_reader :installation_specific_fields, :section_name

    def new_attribute_values
      installation_specific_fields.each_with_object({}) { |attribute, hsh| hsh[attribute.to_sym] = send(attribute) }
    end

    def update_attribute_values(current_attribute_values)
      current_attribute_values[section_name.to_sym].merge(new_attribute_values)
    end

  end
end
