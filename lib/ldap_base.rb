require 'awesome_spawn'
require 'miqldap_configuration'

module MiQLdapToSssd
  class LdapBaseError < StandardError; end

  class LdapBase
    def self.discover(initial_sttings)
      LOGGER.debug("Invokded #{self.class}\##{__method__}")

      params = {
       :x   => nil,
       :H   => "#{initial_settings[:mode]}://#{initial_settings[:ldaphost][0]}:#{initial_settings[:ldapport]}",
       :D   => "#{initial_settings[:bind_dn]}",
       :w   => "#{initial_settings[:bind_pwd]}",
       :s   => "base",
       :b   => "",
      }

      result = AwesomeSpawn.run("ldapsearch -LLL namingContexts", :params => params)

      LOGGER.debug("Ran command: #{result.command_line}")

      if result.failure?
        error_message = "ldapsearch failed with: #{result.error}"
        LOGGER.fatal(error_message)
        raise LdapBaseError.new error_message
      end

      LOGGER.debug("returning ->#{result.output.split("\n")[1].split(" ")[1]}<-")
      result.output.split("\n")[1].split(" ")[1]
    end
  end
end
