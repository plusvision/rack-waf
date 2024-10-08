require_relative "lib/rack/waf/version"

Gem::Specification.new do |spec|
  spec.name = "rack-waf"
  spec.version = Rack::WAF::VERSION
  spec.authors = ["PlusVision,Inc."]
  spec.email = ["rack-waf@plusvision.co.jp"]

  spec.summary = "rack-waf is a Web Application Firewall for Rack."
  spec.description = "rack-waf is a Web Application Firewall for Rack."
  spec.homepage = "https://github.com/plusvision/rack-waf"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/plusvision/rack-waf"
  spec.metadata["changelog_uri"] = "https://github.com/plusvision/rack-waf/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
