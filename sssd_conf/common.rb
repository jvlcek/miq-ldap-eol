module MiQLdapToSssd
  SSSD_CONF_FILE = "/Users/jvlcek/MYJUNK/LANGUAGES/RUBY/EXAMPLES/MIQLDAP_2_SSSD/sssd.conf".freeze

  class SssdConfCommon
    def new_attribute_values
      installation_specific_fields.each_with_object({}) { |attribute, hsh| hsh[attribute.to_sym] = send(attribute) }
    end

    def current_attribute_values
      result = {}

      sssd_conf_file = File.open(SSSD_CONF_FILE, "r")
      while (line = sssd_conf_file.gets)
        line = line.strip.downcase
        next unless line.start_with?("[#{section_name}")

        while (line = sssd_conf_file.gets)
          line = line.strip.downcase
          return result if line.start_with?("[")
          next if line.match(/\s*=\s*/).nil?
          result[line.match(/\s*=\s*/).pre_match.to_sym] = line.match(/\s*=\s*/).post_match
        end
      end
      result
    end

    def update_attribute_values
      # replace section in file with new has
    end
  end
end
