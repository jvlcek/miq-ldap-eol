require 'fileutils'
require 'inifile'

module MiQLdapToSssd
  NORMALIZE_MODES = ['httpd', 'ldaps', 'ldap'].freeze

  class ConfigureDatabaseError < StandardError; end

  class ConfigureDatabase
    attr_reader :initial_settings, :sssd_domain

    def initialize(initial_sttings)
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      @initial_settings = initial_sttings
      @sssd_domain = domain_from_sssd

      LOGGER.debug("#{__method__} initial_settings #{initial_settings}")
      LOGGER.debug("#{__method__} sssd_domain #{sssd_domain}")
    end

    def normalize_userids_to_upn
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      LOGGER.debug("Normalizing userids to User Principal Name (UPN)")

      return unless NORMALIZE_MODES.include? Settings.authentication.to_hash[:mode]

      User.all.map do |u|
        next if u.userid == "admin"

        LOGGER.debug("Updating userid #{u.userid}")

        case
        when u.userid.include?(",")
          LOGGER.debug("Generated from an MiqLdap login using OpenLdap")
          u.userid = dn_to_upn(u.userid)
        when u.userid.include?("@")
          LOGGER.debug("Generated from an MiqLdap login using Active Directory")
          u.userid = u.userid.downcase
        else
          LOGGER.debug("Generated from an SSSD login")
          u.userid = "#{u.userid}@#{sssd_domain}".downcase
        end

        check_duplicate_u = User.lookup_by_identity(u.userid)
        if check_duplicate_u.nil? || check_duplicate_u.id == u.id
          LOGGER.debug("Saving userid #{u.userid}")
          u.save
        else
          LOGGER.debug("Deleting this user, duplicate found #{u.id}")
          u.delete
        end
      end
    end

    private

    def domain_from_sssd
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      sssd_ini = IniFile.load(SSSD_CONF_FILE)
      return if sssd_ini.nil?

      sssd_ini.sections[sssd_ini.sections.index{|s| s.include?("domain/")}].split("/")[1]
    end

    def dn_to_upn(userid)
      LOGGER.debug("Invokded #{self.class}\##{__method__}")
      domain = userid.split(",").collect { |p| p.split('dc=')[1] }.compact.join('.')
      user = userid.split(",").collect { |p| p.split('=')[1] }[0]

      "#{user}@#{domain}".downcase
    end

  end
end

