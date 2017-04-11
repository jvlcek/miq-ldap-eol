require 'sssd_conf/common'

module MiQLdapToSssd
  class Ifp < Common
    def initialize(initial_settings)
      super(%w(allowed_uids user_attributes), initial_settings)
    end

    def allowed_uids
      "apache, root"
    end

    def user_attributes
      "+mail, +givenname, +sn, +displayname"
    end
  end
end
