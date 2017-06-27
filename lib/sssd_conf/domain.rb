require 'sssd_conf/common'

module MiQLdapToSssd
  class Domain < Common

    attr_accessor :active_directory

    def initialize(initial_settings)
      case initial_settings[:user_type]
      when "userprincipalname", "mail", "samaccountname"
        self.active_directory = true
      when "dn-uid", "dn-cn"
        self.active_directory = false
      else
        raise Exception.new("Invalid user_type ->#{initial_settings[:user_type]}<-")
      end

      super(%w(entry_cache_timeout
               ldap_auth_disable_tls_never_use_in_production
               ldap_default_bind_dn
               ldap_default_authtok
               ldap_group_member
               ldap_group_name
               ldap_group_object_class
               ldap_group_search_base
               ldap_network_timeout
               ldap_pwd_policy
               ldap_schema
               ldap_tls_cacert
               ldap_tls_cacertdir
               ldap_user_extra_attrs
               ldap_user_gid_number
               ldap_user_name
               ldap_user_object_class
               ldap_user_search_base
               ldap_user_uid_number), initial_settings)
    end

    def entry_cache_timeout
      "600"
    end

    def ldap_auth_disable_tls_never_use_in_production
      initial_settings[:mode] == "ldaps" ? false : true
    end

    def ldap_default_bind_dn
      initial_settings[:bind_dn]
    end

    def ldap_default_authtok
      initial_settings[:bind_pwd]
    end

    # TODO JJV Is this always the same? If not how can I get it?
    # JJV might be able to leverage ldapsearch:
    # JJV: ldapsearch -x -H "#{initial_settings[:mode]}://#{initial_settings[:ldaphost].first}:#{initial_settings[:ldapport]}"
    def ldap_group_member
      "member"
    end

    # TODO JJV Is this always the same? If not how can I get it?
    # JJV: ldapsearch -x -H "#{initial_settings[:mode]}://#{initial_settings[:ldaphost].first}:#{initial_settings[:ldapport]}"
    def ldap_group_name
      "cn"
    end

    # TODO JJV Is this always the same? If not how can I get it?
    # JJV: ldapsearch -x -H "#{initial_settings[:mode]}://#{initial_settings[:ldaphost].first}:#{initial_settings[:ldapport]}"
    def ldap_group_object_class
      return "group" if active_directory
      "groupOfNames"
    end

    def ldap_group_search_base
      initial_settings[:basedn]
    end

    def ldap_network_timeout
      "3"
    end

    def ldap_pwd_policy
      "none"
    end

    def ldap_schema
      return "AD" if active_directory
      "rfc2307bis"
    end

    def ldap_tls_cacert
      initial_settings[:mode] == "ldaps" ? initial_settings[:tls_cacert] : nil
    end

    def ldap_tls_cacertdir
      initial_settings[:mode] == "ldaps" ?  initial_settings[:tls_cacertdir] : "/etc/openldap/cacerts/"
    end

    def ldap_user_extra_attrs
      "mail, givenname, sn, displayname, domainname"
    end

    def ldap_user_gid_number
      return "primaryGroupID" if active_directory
      "gidNumber"
    end

    def ldap_user_name
      return if active_directory

      case initial_settings[:user_type]
      when "dn-uid"
        "uid"
      when "dn-cn"
        "cn"
      else
        raise Exception.new("Invalid user_type ->#{initial_settings[:user_type]}<-")
      end
    end

    def ldap_user_object_class
      "person"
    end

    def ldap_user_search_base
      return initial_settings[:basedn] if active_directory
      initial_settings[:user_suffix]
    end

    def ldap_user_uid_number
      "uidNumber"
    end
  end
end
