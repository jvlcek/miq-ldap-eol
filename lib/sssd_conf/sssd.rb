require 'sssd_conf/common'

module MiQLdapToSssd
  class Sssd < Common
    def initialize
      super %w(
        default_domain_suffix
        domains
        sbus_timeout
        services
      )
    end

    def default_domain_suffix
      "new_value default_domain_suffix"
    end

    def domains
      "new_value domains"
    end

    def sbus_timeout
      "30"
    end

    def services
      "nss, pam, ifp"
    end
  end
end
