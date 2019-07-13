# -*- encoding: utf-8 -*-
# stub: celluloid-essentials 0.20.5 ruby lib

Gem::Specification.new do |s|
  s.name = "celluloid-essentials".freeze
  s.version = "0.20.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tony Arcieri".freeze, "Donovan Keme".freeze]
  s.date = "2015-09-30"
  s.description = "Notifications, Internals, Logging, Probe, and essential Celluloid pieces demanding Supervision".freeze
  s.email = ["tony.arcieri@gmail.com".freeze, "code@extremist.digital".freeze]
  s.homepage = "https://github.com/celluloid/celluloid-essentials".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Internally used tools, and superstructural dependencies of Celluloid".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<nenv>.freeze, [">= 0"])
      s.add_development_dependency(%q<dotenv>.freeze, [">= 0"])
      s.add_development_dependency(%q<benchmark_suite>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<transpec>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-retry>.freeze, [">= 0"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_development_dependency(%q<celluloid>.freeze, [">= 0.17.2"])
      s.add_development_dependency(%q<celluloid-supervision>.freeze, [">= 0"])
      s.add_development_dependency(%q<celluloid-pool>.freeze, [">= 0"])
      s.add_development_dependency(%q<celluloid-fsm>.freeze, [">= 0"])
      s.add_development_dependency(%q<celluloid-extras>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<timers>.freeze, [">= 4.1.1"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<nenv>.freeze, [">= 0"])
      s.add_dependency(%q<dotenv>.freeze, [">= 0"])
      s.add_dependency(%q<benchmark_suite>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<transpec>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-retry>.freeze, [">= 0"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_dependency(%q<celluloid>.freeze, [">= 0.17.2"])
      s.add_dependency(%q<celluloid-supervision>.freeze, [">= 0"])
      s.add_dependency(%q<celluloid-pool>.freeze, [">= 0"])
      s.add_dependency(%q<celluloid-fsm>.freeze, [">= 0"])
      s.add_dependency(%q<celluloid-extras>.freeze, [">= 0"])
      s.add_dependency(%q<timers>.freeze, [">= 4.1.1"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<nenv>.freeze, [">= 0"])
    s.add_dependency(%q<dotenv>.freeze, [">= 0"])
    s.add_dependency(%q<benchmark_suite>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<transpec>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-retry>.freeze, [">= 0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_dependency(%q<celluloid>.freeze, [">= 0.17.2"])
    s.add_dependency(%q<celluloid-supervision>.freeze, [">= 0"])
    s.add_dependency(%q<celluloid-pool>.freeze, [">= 0"])
    s.add_dependency(%q<celluloid-fsm>.freeze, [">= 0"])
    s.add_dependency(%q<celluloid-extras>.freeze, [">= 0"])
    s.add_dependency(%q<timers>.freeze, [">= 4.1.1"])
  end
end
