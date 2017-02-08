#!/usr/bin/env ruby

# Simulate rubygems adding the top level appliance_console.rb's directory to the path.
$LOAD_PATH.push(File.dirname(__FILE__))

require 'sssd_conf/domain'
require 'sssd_conf/sssd'

require 'pp' # JJV REMOVE

module MiQLdapToSssd
  SSSD_CONF_FILE = "/Users/jvlcek/MYJUNK/LANGUAGES/RUBY/EXAMPLES/MIQLDAP_2_SSSD/sssd.conf_POST_AUTHCONFIG".freeze

  class SssdConf
    attr_accessor :sssd_conf_contents

    def initialize
      @sssd_conf_contents = sssd_conf2hash
    end

    def update
      [Sssd, Domain].each do |section_class|
        section = section_class.new
        sssd_conf_contents[section.section_name.to_sym] = section.update_attribute_values(sssd_conf_contents)
      end

      pp sssd_conf_contents # JJV TODO remove this line
      write_updates(sssd_conf_contents)
      sssd_conf_contents # JJV TODO remove this line
    end

    private

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

    def current_sections
      sections = File.open(SSSD_CONF_FILE, "r").grep(/\[/)
      sections.each_with_object({}) do |section, hsh|
        section = "domain" if section.start_with?("[domain")

        hsh[section.gsub(/"|\[|\]/, '').strip.downcase.to_sym] = {}
      end 
    end

    def sssd_conf2hash
      sections_hash = current_sections
      sections_hash.each { |section, _value| sections_hash[section] = current_attribute_values(section) }
    end

    def write_updates(sssd_conf_contents)
      File.open(SSSD_CONF_FILE, "w") do |f|
        sssd_conf_contents.each do |section, values|

          # Domain is a special case because the section title is updated from [domain/default] to [doamin/<new domain>]
          if section == :domain
            f.write("\n[#{Domain.update_domain_value}]\n")
          else
            f.write("\n[#{section.to_s}]\n")
          end
          values.each do |attribute, value|
            f.write("#{attribute.to_s} = #{value}\n")
          end
        end
      end
    end

  end
end
