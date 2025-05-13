# -*- encoding: utf-8 -*-
# stub: solid_cable 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "solid_cable".freeze
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "http://github.com/npezza93/solid_cable", "rubygems_mfa_required" => "true", "source_code_uri" => "http://github.com/npezza93/solid_cable" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nick Pezza".freeze]
  s.date = "2024-06-20"
  s.description = "Database-backed Action Cable backend.".freeze
  s.email = ["pezza@hey.com".freeze]
  s.homepage = "http://github.com/npezza93/solid_cable".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Database-backed Action Cable backend.".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rails>.freeze, ["< 9"])
end
