require 'sssd_conf/common'

module MiQLdapToSssd
  class SssdConfSssd < SssdConfCommon
    SECTION_NAME = "sssd".freeze

    def self.section_name_sym
      SECTION_NAME.to_sym
    end

    def initialize
      @section_name = SECTION_NAME
      @installation_specific_fields = %w(
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
