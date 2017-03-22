require 'miqldap_configuration'

module MiQLdapToSssd
  class Common < MiqLdapConfiguration

    attr_reader :installation_specific_fields

    def initialize(installation_specific_fields)
      puts "JJV Called #{__FILE__} - #{__method__}"
      @installation_specific_fields = installation_specific_fields
      super()
    end

    def section_name
      puts "JJV Called #{__FILE__} - #{__method__}"
      self.class.name.downcase.split('::').last
    end

    def new_attribute_values
      puts "JJV Called #{__FILE__} - #{__method__}"
      installation_specific_fields.each_with_object({}) { |attribute, hsh| hsh[attribute.to_sym] = send(attribute) }
    end

    def update_attribute_values(current_attribute_values)
      puts "JJV Called #{__FILE__} - #{__method__}"
      current_attribute_values[section_name.to_sym].merge(new_attribute_values)
    end

  end
end
