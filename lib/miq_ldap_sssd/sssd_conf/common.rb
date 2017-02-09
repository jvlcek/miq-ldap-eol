module MiQLdapToSssd
  class Common
    attr_reader :installation_specific_fields, :miqldap_settings

    def initialize(installation_specific_fields)
      @installation_specific_fields = installation_specific_fields
      @miqldap_settings = miqldap_auth_settings
    end

    def section_name
      self.class.name.downcase.split('::').last
    end

    def new_attribute_values
      installation_specific_fields.each_with_object({}) { |attribute, hsh| hsh[attribute.to_sym] = send(attribute) }
    end

    def update_attribute_values(current_attribute_values)
      current_attribute_values[section_name.to_sym].merge(new_attribute_values)
    end

    private

    def miqldap_auth_settings
      # JJV comment for testing -> ::Settings.authentication.to_hash

      # JJV temporary testing data
      { :basedn                      => "ou=groups,ou=prod,dc=jvlcek,dc=com",
        :bind_dn                     => "cn=Manager,dc=jvlcek,dc=com",
        :bind_pwd                    => "secret",
        :get_direct_groups           => true,
        :group_memberships_max_depth => 2,
        :ldaphost                    => ["joev-openldap.jvlcek.redhat.com"],
        :ldapport                    => "636",
        :mode                        => "ldaps",
        :user_suffix                 => "ou=people,ou=prod,dc=jvlcek,dc=com",
        :user_type                   => "dn-cn",
        :amazon_key                  => nil,
        :amazon_secret               => nil,
        :default_group_for_users     => "joev-ldap-group",
        :domain_prefix               => "",
        :local_login_disabled        => false,
        :saml_enabled                => false,
        :sso_enabled                 => false,
        :follow_referrals            => false,
        :user_proxies                => [{}],
        :httpd_role                  => false,
        :amazon_role                 => false,
        :ldap_role                   => true
      }


    end
  end
end
