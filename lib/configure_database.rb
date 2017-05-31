require 'fileutils'

module MiQLdapToSssd
  NORMALIZE_MODES = ['httpd', 'ldaps', 'ldap'].freeze

  class ConfigureDatabaseError < StandardError; end

  class ConfigureDatabase
    attr_reader :initial_settings

    def initialize(initial_sttings)
      @initial_settings = initial_sttings
      @domain = "GOD ONLY KNOWS" #  :) JJV
    end

    def normalize_userids_to_upn

      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      LOGGER.debug("Normalizing userids to User Principal Name (UPN)")

      return unless NORMALIZE_MODES.include? Settings.authentication.to_hash[:mode]

      User.all.map do |u|

        next if u[:userid] == "admin"
        next if u[:userid].include? "@" # u[:userid] is already UPN

        LOGGER.debug("Updating userid u[:userid]")

        if u[:userid].include? ","
          Strip u[:userid] from Distinguished Name (DC)
          # JJV START HERE
        end

        u[:userid] = "#{u[:userid]}@#{domain}"

        LOGGER.debug("New userid u[:userid]")

        u.save
      end
    end

      LOGGER.debug("Initial httpd_role: #{update.config[:authentication][:httpd_role]}")
      LOGGER.debug("Initial  ldap_role: #{update.config[:authentication][:ldap_role]}")

      update.config[:authentication][:mode] = "httpd"
      update.config[:authentication][:httpd_role] = update.config[:authentication][:ldap_role]
      update.config[:authentication][:ldap_role]  = false

      LOGGER.debug("Updated       mode: #{update.config[:authentication][:mode]}")
      LOGGER.debug("Updated httpd_role: #{update.config[:authentication][:httpd_role]}")
      LOGGER.debug("Updated  ldap_role: #{update.config[:authentication][:ldap_role]}")

      update.save
    end

  end
end
