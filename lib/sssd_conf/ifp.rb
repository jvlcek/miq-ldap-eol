require 'sssd_conf/common'

module MiQLdapToSssd
  class Ifp < Common
    def initialize(_initial_settings)
      super %w(default_domain_suffix allowed_uids user_attributes)
    end

    def default_domain_suffix
      initial_settings[:basedn].split(",").collect { |p| p.split('=')[1] }.join('.')
    end

    def allowed_uids
      "apache, root"
    end

    def user_attributes
      "+mail, +givenname, +sn, +displayname"
    end
  end
end
