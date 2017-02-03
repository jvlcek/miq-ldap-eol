require 'sssd_conf/common'

module MiQLdapToSssd
  class SssdConfDomain < SssdConfCommon
    def initialize
      @section_name = "domain"
      @installation_specific_fields = %w(
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

    def entry_cache_timeout
      "entry_cache_timeout new_value"
    end

    def ldap_group_member
      "ldap_group_member new_value"
    end

    def ldap_group_name
      "ldap_group_name new_value"
    end

    def ldap_group_object_class
      "ldap_group_object_class new_value"
    end

    def ldap_group_search_base
      "ldap_group_search_base new_value"
    end

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
