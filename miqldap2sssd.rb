#!/usr/bin/env ruby

# Simulate rubygems adding the top level appliance_console.rb's directory to the path.
$LOAD_PATH.push(File.dirname(__FILE__))

require 'pp'

require 'sssd_conf/domain'
require 'sssd_conf/sssd'

module MiQLdapToSssd
  def self.display_merge(obj)
    current     = obj.current_attribute_values
    new         = obj.new_attribute_values
    replacement = current.merge(new)

    puts "\n+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-=+-="
    puts "current"
    pp   current

    puts "\n   New:"
    pp new

    puts "\n  Replacement:"
    pp replacement
  end

  if __FILE__ == $PROGRAM_NAME
    display_merge(SssdConfSssd.new)
    display_merge(SssdConfDomain.new)
  end
end
