require 'awesome_spawn'
require 'miqldap_configuration'

module MiQLdapToSssd
  class MiqLdapAuthConfig

    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
    end

    def run_auth_config
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
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
