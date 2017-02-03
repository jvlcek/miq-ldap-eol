#!/usr/bin/env ruby

# Simulate rubygems adding the top level appliance_console.rb's directory to the path.
$LOAD_PATH.push(File.dirname(__FILE__))

require 'sssd_conf/domain'
require 'sssd_conf/sssd'

module MiQLdapToSssd
  class SssdConf
    def self.update
      sssd_conf_section_classes = [SssdConfSssd, SssdConfDomain]
      # Write updates to sssd_conf
      # unless sssd.conf.miq_orig cp sssd.conf to sssd.conf.miq_orig
      sssd_conf_section_classes.map do |section_class|
        section_class.new.update_attribute_values
      end
    end
  end
end
