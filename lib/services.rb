require 'linux_admin'

module MiQLdapToSssd
  class Services

    def self.restart
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      LOGGER.debug("\nRestarting httpd, if running ...")
      httpd_service = LinuxAdmin::Service.new("httpd")
      httpd_service.restart if httpd_service.running?
      
      LOGGER.debug("Restarting sssd and configure it to start on reboots ...")
      LinuxAdmin::Service.new("sssd").restart.enable
    end

  end
end
