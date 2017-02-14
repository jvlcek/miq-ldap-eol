require 'sssd_conf/common'

module MiQLdapToSssd
  class Pam < Common
    def initialize
      super %w(default_domain_suffix)
    end

    def default_domain_suffix
      "new_value default_domain_suffix"
    end
  end
end
