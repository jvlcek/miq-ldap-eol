#!/usr/bin/env ruby

# Simulate rubygems adding the top level appliance_console.rb's directory to the path.
$LOAD_PATH.push(File.dirname(__FILE__))

require 'pp'

require 'sssd_conf'
require 'sssd_conf/domain'
require 'sssd_conf/sssd'

module MiQLdapToSssd
  if __FILE__ == $PROGRAM_NAME
    pp SssdConf.update
  end
end
