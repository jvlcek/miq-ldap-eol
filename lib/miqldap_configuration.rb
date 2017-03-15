require 'trollop'

module MiQLdapToSssd
  class MiqLdapConfiguration

    def self.authentication_settings
      # TODO JJV comment for testing -> ::Settings.authentication.to_hash

      # TODO JJV temporary testing data
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

    def self.user_provided_settings
      # TODO JJV These settings will be gathered from the user
      # TODO JJV temporary testing data

      opts = Trollop::options do
        opt :tls_cacert,
            "Path to certificate file",
            :short => "-c",
            :default => "/path/to/certificate_dir/cert_file",
            :type => :string
      end 

      opts[:tls_cacertdir] = File.dirname(opts[:tls_cacert])
      opts
    end
 
  end
end
