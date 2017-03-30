require 'awesome_spawn'

module MiQLdapToSssd
  class MiqLdapToSssdConfigureSELinuxError < StandardError; end

  class MiqLdapConfigureSELinux
    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
    end

    def configure
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      enable_non_standard_ldap_port("10636")
      enable_non_standard_ldap_port("10389")

      set_permission("allow_httpd_mod_auth_pam")
      set_permission("httpd_dbus_sssd")
    end

    private

    def enable_non_standard_ldap_port(port_number)
      LOGGER.debug("Invokded #{self.class}\##{__method__}(#{port_number})")

      params = {
        nil => "port",
        :a => nil,
        :t => "ldap_port_t",
        :p => ["tcp", port_number]
      }

      result = AwesomeSpawn.run("semanage", :params => params)

      if result.failure?
        error_message = "semanage failed with: #{result.error}"
        LOGGER.fatal(error_message)
        raise MiqLdapToSssdConfigureSELinuxError.new error_message
      end
    end

    def set_permission(permission_name)
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      params = {:P => [permission_name, "on"] }

      result = AwesomeSpawn.run("setsebool", :params => params)

      if result.failure?
        error_message = "setsebool failed with: #{result.error}"
        LOGGER.fatal(error_message)
        raise MiqLdapToSssdConfigureSELinuxError.new error_message
      end
    end

  end
end
