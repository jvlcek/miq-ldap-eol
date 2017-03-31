require 'fileutils'

module MiQLdapToSssd
  class ConfigureSssdRulesError < StandardError; end

  class ConfigureSssdRules
    CFG_RULES_FILE = "/usr/share/sssd/cfg_rules.ini"

    def self.disable_tls
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      begin
        open(CFG_RULES_FILE, 'a') do |f|
          f << "option = ldap_auth_disable_tls_never_use_in_production\n"
        end
      rescue Errno::ENOENT => err
        LOGGER.fatal(err.message)
        raise ConfigureSssdRulesError.new err.message
      end
    end

  end
end
