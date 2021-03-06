require 'iniparse'
require 'sssd_conf/domain'
require 'sssd_conf/ifp'
require 'sssd_conf/pam'
require 'sssd_conf/sssd'

module MiQLdapToSssd
  class SssdConf
    attr_reader :initial_settings, :sssd_conf_contents

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
      @sssd_conf_contents = sssd_conf_to_hash
    end

    def update
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      [Domain, Sssd, Pam, Ifp].each do |section_class|
        section = section_class.new(initial_settings)
        sssd_conf_contents[section.section_name.to_sym] = section.update_attribute_values(sssd_conf_contents)
      end

      write_updates(sssd_conf_contents)
    end

    private

    def sssd_conf_to_hash
      IniParse.open(SSSD_CONF_FILE).to_hash.deep_transform_keys! do |key|
        key = key.downcase
        if key.start_with?("domain/")
          :domain 
        else
          key.to_sym
        end
      end
    end 

    def write_updates(sssd_conf_contents)
      File.open(SSSD_CONF_FILE, "w") do |f|
        sssd_conf_contents.each do |section, values|
          if section == :domain
            f.write("\n[domain/#{initial_settings[:basedn_domain]}]\n")
            f.write("\n[application/#{initial_settings[:basedn_domain]}]\n")
          else
            f.write("\n[#{section.to_s}]\n")
          end
          values.each do |attribute, value|
            f.write("#{attribute.to_s} = #{value}\n")
          end
        end
      end
    end

  end
end
