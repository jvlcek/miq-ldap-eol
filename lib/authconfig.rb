require 'awesome_spawn'
require 'miqldap_configuration'

module MiQLdapToSssd
  class MiqLdapAuthConfig < MiqLdapConfiguration

    def run_auth_config
      params = {
        :ldapserver=        => "#{initial_settings[:mode]}://#{initial_settings[:ldaphost][0]}:#{initial_settings[:ldapport]}",
        :ldapbasedn=        => "#{initial_settings[:ldapbasedn]}",
        :enablesssd         => nil,
        :enablesssdauth     => nil,
        :enablelocauthorize => nil,
        :enableldap         => nil,
        :enableldapauth     => nil,
        :disableldaptls     => nil,
        :enablerfc2307bis   => nil,
        :enablecachecreds   => nil,
        :update             => nil
      }

      result = AwesomeSpawn.run("authconfig", :params => params)
      puts result.error if result.failure?
    end
  end
end
