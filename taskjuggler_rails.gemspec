require_relative "lib/taskjuggler_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "taskjuggler-rails"
  spec.version     = TaskjugglerRails::VERSION
  spec.authors     = [ "Nathan Kidd" ]
  spec.email       = [ "nathankidd@hey.com" ]
  spec.homepage    = "https://github.com/n-at-han-k/taskjuggler-rails"
  spec.summary     = "Render Taskjuggler files (.tjp) as controller views."
  spec.description = spec.summary

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "LICENSE", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2"
  spec.add_dependency "taskjuggler", "~> 3.8"
end
