require 'sssd_conf/common'

module MiQLdapToSssd
  class Pam < Common
    def initialize(_initial_settings)
      super %w(default_domain_suffix)
    end

    def default_domain_suffix
      initial_settings[:basedn].split(",").collect { |p| p.split('=')[1] }.join('.')
    end
  end
end
