require 'sssd_conf/common'

module MiQLdapToSssd
  class Pam < Common
    def initialize(_initial_settings)
      super(%w(pam_app_services), _initial_settings)
    end

    def pam_app_services
      "httpd-auth"
    end
  end
end

