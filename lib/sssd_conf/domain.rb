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
        ldap_auth_disable_tls_never_use_in_production
        ldap_user_extra_attrs
        ldap_user_name
        ldap_user_object_class
        ldap_user_gid_number
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

    def ldap_tls_cacert
      initial_settings[:mode] == "ldaps" ? initial_settings[:tls_cacert] : nil
    end

    def ldap_tls_cacertdir
      initial_settings[:mode] == "ldaps" ?  initial_settings[:tls_cacertdir] : nil
    end

    def ldap_auth_disable_tls_never_use_in_production
      initial_settings[:mode] == "ldaps" ? false : true
    end

    def ldap_user_extra_attrs
      "mail, givenname, sn, displayname"
    end

    def ldap_user_name
      case initial_settings[:user_type]
      when "userprincipalname"
        return "userprincipalname"
      when "mail"
        return "mail"
      when "dn-uid"
        return "uid"
      when "dn-cn"
        "cn"
      when "samaccountname"
        return "samaccountname"
      else
        raise Exception.new("Invalid user_type ->#{initial_settings[:user_type]}<-")
      end
    end

    def ldap_user_object_class
      # TODO ??? Could this be lPerson, organizationalPerson or posixAccount
      "posixAccount NEED POSIX ??? TODO ???"
    end

    def ldap_user_gid_number
      "gidNumber NEED POSIX ??? TODO ???"
    end

    def ldap_user_search_base
      case initial_settings[:user_type]
      when "userprincipalname"
        return "??? TODO ???"
      when "mail"
        return "??? TODO ???"
      when "dn-uid"
        return initial_settings[:user_suffix]
      when "dn-cn"
        return initial_settings[:user_suffix]
      when "samaccountname"
        return "??? TODO ???"
      else
        raise Exception.new("Invalid user_type ->#{initial_settings[:user_type]}<-")
      end
    end

    def ldap_user_uid_number
      "uidNumber NEED POSIX ??? TODO ???"
    end
  end
end
