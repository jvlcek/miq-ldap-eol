require 'sssd_conf/common'

module MiQLdapToSssd
  class Domain < Common
    def initialize
      super %w(
        entry_cache_timeout
        ldap_group_member
        ldap_group_name
        ldap_group_object_class
        ldap_group_search_base
        ldap_network_timeout
        ldap_pwd_policy
        ldap_tls_cacert
        ldap_tls_cacertdir
        ldap_user_extra_attrs
        ldap_user_name
        ldap_user_object_class
        ldap_user_search_base
        ldap_user_uid_number
      )
    end

    # Domain is a special case because the section title is updated from [domain/default] to [doamin/<new domain>]
    def self.update_domain_value
      "domain/my_domain.com"
    end

    def entry_cache_timeout
      "600"
    end

    # JJV ? Is this always the same?
    def ldap_group_member
      "member"
    end

    # JJV ? Is this always the same?
    def ldap_group_name
      "cn"
    end

    # JJV ? Is this always the same?
    def ldap_group_object_class
      "posixAccount"
    end

    def ldap_group_search_base
      "#{miqldap_settings[:basedn]}"
    end

    # JJV START HERE
    def ldap_network_timeout
      "ldap_network_timeout new_value"
    end

    def ldap_pwd_policy
      "ldap_pwd_policy new_value"
    end

    def ldap_tls_cacert
      "ldap_tls_cacert new_value"
    end

    def ldap_tls_cacertdir
      "ldap_tls_cacertdir new_value"
    end

    def ldap_user_extra_attrs
      "ldap_user_extra_attrs new_value"
    end

    def ldap_user_name
      "ldap_user_name new_value"
    end

    def ldap_user_object_class
      "ldap_user_object_class new_value"
    end

    def ldap_user_search_base
      "ldap_user_search_base new_value"
    end

    def ldap_user_uid_number
      "ldap_user_uid_number new_value"
    end
  end
end
