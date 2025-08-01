# frozen_string_literal: true

require_relative "lib/instagram_publish_api_via_instagram_login/version"

Gem::Specification.new do |spec|
  spec.name = "instagram_publish_api_via_instagram_login"
  spec.version = InstagramPublishApiViaInstagramLogin::VERSION
  spec.authors = ["Vadym Kruchyna"]
  spec.email = ["kruchina.vadim@gmail.com"]

  spec.summary = "Ruby gem for publishing media to Instagram using Instagram Basic Display API"
  spec.description = "A comprehensive Ruby library for Instagram media publishing with OAuth authentication, user information retrieval, and support for images, videos, carousels with captions. Features include token management, error handling, and clean separation of concerns."
  spec.homepage = "https://github.com/ninjarender/instagram_publish_api_via_instagram_login"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ninjarender/instagram_publish_api_via_instagram_login"
  spec.metadata["changelog_uri"] = "https://github.com/ninjarender/instagram_publish_api_via_instagram_login/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/ninjarender/instagram_publish_api_via_instagram_login/issues"
  spec.metadata["documentation_uri"] = "https://github.com/ninjarender/instagram_publish_api_via_instagram_login/blob/main/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "json", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
