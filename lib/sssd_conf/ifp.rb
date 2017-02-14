require 'sssd_conf/common'

module MiQLdapToSssd
  class Ifp < Common
    def initialize
      super %w(default_domain_suffix allowed_uids user_attributes)
    end

    def default_domain_suffix
      "new_value default_domain_suffix"
    end

    def allowed_uids
      "apache, root"
    end

    def user_attributes
      "+mail, +givenname, +sn, +displayname"
    end
  end
end
