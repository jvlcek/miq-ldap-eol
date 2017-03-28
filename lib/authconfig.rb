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
        :ldapbasedn=        => "#{initial_settings[:basedn].split(",").collect { |p| p.split('=')[1] }.join('.')}",
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

      if result.failure?
        error_message = "authconfig failed with: #{result.error}"
        LOGGER.fatal(error_message)
        raise MiqLdapToSssdArgumentError.new error_message
      end
    end
  end
end
