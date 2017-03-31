require 'awesome_spawn'
require 'miqldap_configuration'

module MiQLdapToSssd
  class AuthConfigError < StandardError; end

  class AuthConfig

    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
    end

    def run_auth_config
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      params = {
        :ldapserver=        => "#{initial_settings[:mode]}://#{initial_settings[:ldaphost][0]}:#{initial_settings[:ldapport]}",
        :ldapbasedn=        => initial_settings[:basedn],
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
      LOGGER.debug("Ran command: #{result.command_line}")

      if result.failure?
        error_message = "authconfig failed with: #{result.error}"
        LOGGER.fatal(error_message)
        raise AuthConfigError.new error_message
      end
    end
  end
end
