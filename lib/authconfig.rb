require 'awesome_spawn'
require 'miqldap_configuration'

module MiQLdapToSssd
  class MiqLdapAuthConfig < MiqLdapConfiguration

    def run_auth_config
      puts "JJV Called #{__FILE__} - #{__method__}"

      puts "JJV initial_settings START"
      require 'pp'
      pp initial_settings
      puts "JJV initial_settings END"

      # :ldapserver         => ldaps://joev-openldap.jvlcek.redhat.com:636 \
      params =  { :ldapserver=        => "#{initial_settings[:mode]}://#{initial_settings[:ldaphost][0]}:#{initial_settings[:ldapport]}",
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

      ApplianceConsole::Logging.logger.error(result.error) if result.failure?

      puts "JJV Called #{__FILE__} - #{__method__} result.output ->#{result.output}<-"

      result
      end
  end
end
