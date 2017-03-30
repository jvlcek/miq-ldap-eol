require 'fileutils'

module MiQLdapToSssd
  class MiqLdapToSssdConfigureApacheError < StandardError; end

  class MiqLdapConfigureApache
    TEMPLATE_DIR = "/var/www/miq/system/TEMPLATE".freeze
    HTTPD_CONF_DIR = "/etc/httpd/conf.d".freeze
    PAM_CONF_DIR = "/etc/pam.d".freeze

    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
    end

    def configure
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      create_files
      update_realm
    end

    private

    def create_files
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      begin
        FileUtils.cp("#{TEMPLATE_DIR}#{PAM_CONF_DIR}/httpd-auth", "#{PAM_CONF_DIR}/httpd-auth")
        FileUtils.cp("#{TEMPLATE_DIR}#{HTTPD_CONF_DIR}/manageiq-remote-user.conf", "#{HTTPD_CONF_DIR}")
        FileUtils.cp("#{TEMPLATE_DIR}#{HTTPD_CONF_DIR}/manageiq-external-auth.conf.erb", "#{HTTPD_CONF_DIR}/manageiq-external-auth.conf")
      rescue Errno::ENOENT => err
        LOGGER.fatal(err.message)
        raise MiqLdapToSssdConfigureApacheError.new err.message
      end
    end

    def update_realm
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      begin
        miq_ext_auth = File.read("#{HTTPD_CONF_DIR}/manageiq-external-auth.conf")
        miq_ext_auth[/(\s*)KrbAuthRealms(\s*)(.*)/, 3] = 'BOBS_YOUR_UNCLE'
        File.write("#{HTTPD_CONF_DIR}/manageiq-external-auth.conf", miq_ext_auth)
      rescue Errno::ENOENT => err
        LOGGER.fatal(err.message)
        raise MiqLdapToSssdConfigureApacheError.new err.message
      end
    end

  end
end
