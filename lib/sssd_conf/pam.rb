require 'sssd_conf/common'

module MiQLdapToSssd
  class Pam < Common
    def initialize(initial_settings)
      super(%w(default_domain_suffix), initial_settings)
    end

    def default_domain_suffix
      initial_settings[:basedn_domain]
    end
  end
end
