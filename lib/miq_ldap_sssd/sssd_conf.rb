#!/usr/bin/env ruby

# Simulate rubygems adding the top level appliance_console.rb's directory to the path.
$LOAD_PATH.push(File.dirname(__FILE__))

require 'sssd_conf/domain'
require 'sssd_conf/sssd'

module MiQLdapToSssd
  SSSD_CONF_FILE = "/Users/jvlcek/MYJUNK/LANGUAGES/RUBY/EXAMPLES/MIQLDAP_2_SSSD/sssd.conf_POST_AUTHCONFIG".freeze

  class SssdConf
    attr_accessor :sssd_conf_initial_contents

    def initialize
      @sssd_conf_initial_contents = sssd_conf2hash
    end

    def sssd_conf2hash
      x = current_sections
      x.each { |section, value| x[section] = current_attribute_values(section) }
    end

    def current_sections
      sections = File.open(SSSD_CONF_FILE).grep(/\[/)
      sections.each_with_object({}) do |section, hsh|
        section = "domain" if section.start_with?("[domain")

        hsh[section.gsub(/"|\[|\]/, '').strip.downcase.to_sym] = {}
      end 
    end

    def current_attribute_values(section)
      result = {}

      sssd_conf_file = File.open(SSSD_CONF_FILE, "r")
      while (line = sssd_conf_file.gets)
        line = line.strip.downcase
        next unless line.start_with?("[#{section.to_s}")

        while (line = sssd_conf_file.gets)
          line = line.strip.downcase
          return result if line.start_with?("[")
          next if line.match(/\s*=\s*/).nil?
          result[line.match(/\s*=\s*/).pre_match.to_sym] = line.match(/\s*=\s*/).post_match
        end
      end
      result
    end

    def update
      sssd_conf_section_classes = [Sssd, Domain]
      # Write updates to sssd_conf
      # unless sssd.conf.miq_orig cp sssd.conf to sssd.conf.miq_orig
      sssd_conf_section_classes.each do |section_class|
        section = section_class.new
        sssd_conf_initial_contents[section.section_name.to_sym] = section.update_attribute_values(sssd_conf_initial_contents)
      end
      sssd_conf_initial_contents
    end
  end
end
