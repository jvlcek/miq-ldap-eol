require 'trollop'

module MiQLdapToSssd
  class MiqLdapToSssdArgumentError < StandardError; end
  class MiqLdapToSssdError < StandardError; end

  class MiqLdapConfiguration

    def self.initial_settings
      initial_settings = current_authentication_settings.merge(user_provided_settings)
      if initial_settings[:mode] == "ldaps" && initial_settings[:tls_cacert].nil?
        LOGGER.fatal("Unprovided TLS certificate are required when mode is ldaps")
        raise MiqLdapToSssdArgumentError.new "TLS certificate were not provided and are required when mode is ldaps"
      end

      initial_settings
    end

    def self.current_authentication_settings
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      # TODO JJV comment for testing -> ::Settings.authentication.to_hash
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
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      opts = Trollop::options do
        opt :tls_cacert,
            "Path to certificate file",
            :short => "-c",
            :default => nil,
            :type => :string

        opt :ldapbasedn,
            "The LDAP BaseDN",
            :short => "-b",
            :default => nil,
            :type => :string
      end 

      opts[:tls_cacertdir] = File.dirname(opts[:tls_cacert]) unless opts[:tls_cacert].nil?
      opts
    end
  end
end
