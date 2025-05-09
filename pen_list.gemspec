# frozen_string_literal: true

require_relative "lib/pen_list/version"

Gem::Specification.new do |spec|
  spec.name = "pen_list"
  spec.version = PenList::VERSION
  spec.authors = ["Tyler Elliott"]
  spec.email = ["tylercal@gmail.com"]

  spec.summary = "Common rack-attack configuration to stop pen-testers"
  spec.description = "Pen testers use similar attacks across applications. This gem allows a common configuration for all rails apps."
  spec.homepage = "https://github.com/tylercal/pen_list"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack-attack', ">= 6.7"
  spec.add_dependency 'railties', ">= 3.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
