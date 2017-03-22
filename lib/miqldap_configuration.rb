require 'trollop'

module MiQLdapToSssd
  class MiqLdapConfiguration

    attr_reader :initial_settings

    def initialize
      puts "JJV Called #{__FILE__} - #{__method__}"
      @initial_settings = current_authentication_settings.merge(user_provided_settings)
    end

    def current_authentication_settings
      puts "JJV Called #{__FILE__} - #{__method__}"

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

    def user_provided_settings
      puts "JJV Called #{__FILE__} - #{__method__}"

      # TODO JJV These settings will be gathered from the user
      # TODO JJV temporary testing data

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
