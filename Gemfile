source 'https://rubygems.org'

# Specify your gem's dependencies in manageiq-gems-pending.gemspec
gemspec

# Modified gems (forked on github)
gem "handsoap", "~>0.2.5", :require => false, :git => "https://github.com/ManageIQ/handsoap.git", :tag => "v0.2.5-5"
gem "rubywbem",            :require => false, :git => "https://github.com/ManageIQ/rubywbem.git", :branch => "rubywbem_0_1_0"

gem "trollop"
gem "awesome_spawn"
gem "linux_admin"

group :test do
  gem "simplecov", :require => false
  gem "codeclimate-test-reporter", "~> 1.0.0", :require => false
end
