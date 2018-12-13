lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mongoid/collection_separatable/version"

Gem::Specification.new do |spec|
  spec.name          = "mongoid-collection-separatable"
  spec.version       = Mongoid::CollectionSeparatable::VERSION
  spec.authors       = ["Oscar Jiang"]
  spec.email         = ["pengj0520@gmail.com"]

  spec.summary       = %q{Save the mongoid model into different collections by condition}
  spec.description   = %q{Mongoid models are saved in one collection by default. However, when collections after too large , it could be extracted into a separated one and query form that, to make it query faster}
  spec.homepage      = "https://github.com/warmwind/mongoid_collection_separatable"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/warmwind/mongoid_collection_separatable"
    spec.metadata["changelog_uri"] = "https://github.com/warmwind/mongoid_collection_separatable/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongoid', ' ~> 6.4.0'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4"

end
