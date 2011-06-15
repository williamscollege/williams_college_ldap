# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "williams_college_ldap/version"

Gem::Specification.new do |s|
  s.name        = "williams_college_ldap"
  s.version     = WilliamsCollegeLdap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Courtney Wade"]
  s.email       = ["cwade@williams.edu"]
  s.homepage    = ""
  s.summary     = %q{Williams College LDAP authentication and lookups.}
  s.description = %q{Provides methods for authentication and directory lookups on the Williams College LDAP server.}

  s.require_paths = ["lib"]
  s.add_dependency('net-ldap', '>= 0.1.1')
end
