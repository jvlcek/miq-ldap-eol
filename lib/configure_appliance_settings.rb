require 'fileutils'

module MiQLdapToSssd
  class ConfigureApplianceSettingsError < StandardError; end

  class ConfigureApplianceSettings
    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
    end

    def configure
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      update = MiqServer.my_server(true).get_config("vmdb")

      LOGGER.debug("Initial       mode: #{update.config[:authentication][:mode]}")
      LOGGER.debug("Initial httpd_role: #{update.config[:authentication][:httpd_role]}")
      LOGGER.debug("Initial  ldap_role: #{update.config[:authentication][:ldap_role]}")

      update.config[:authentication][:mode] = "httpd"
      update.config[:authentication][:httpd_role] = update.config[:authentication][:ldap_role]
      update.config[:authentication][:ldap_role]  = false

      LOGGER.debug("Updated       mode: #{update.config[:authentication][:mode]}")
      LOGGER.debug("Updated httpd_role: #{update.config[:authentication][:httpd_role]}")
      LOGGER.debug("Updated  ldap_role: #{update.config[:authentication][:ldap_role]}")

      update.save
    end

  end
end
