require 'miqldap_configuration'

module MiQLdapToSssd
  class Common

    attr_reader :initial_settings, :installation_specific_fields

    def initialize(installation_specific_fields, initial_settings)
      @installation_specific_fields = installation_specific_fields
      @initial_settings = initial_settings
    end

    def section_name
      self.class.name.downcase.split('::').last
    end

    def new_attribute_values
      installation_specific_fields.each_with_object({}) { |attribute, hsh| hsh[attribute.to_sym] = send(attribute) }
    end

    def update_attribute_values(current_attribute_values)
      current_attribute_values[section_name.to_sym] = {} if current_attribute_values[section_name.to_sym].nil?
      current_attribute_values[section_name.to_sym].merge(new_attribute_values)
    end

  end
end
