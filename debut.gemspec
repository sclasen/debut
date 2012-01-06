Gem::Specification.new do |gem|
  gem.name    = "debut"
  gem.version = "1.0"

  gem.author      = "Scott Clasen"
  gem.email       = "scott@heroku.com"
  gem.homepage    = "http://github.com/sclasen/debut"
  gem.summary     = "Builds deb files from a single directory install like a binary tar.gz. Only on ubuntu"
  gem.description = "Builds deb files from a single directory install like a binary tar.gz"
  gem.executables = "debut"

  gem.files = ["lib/debut.rb", "bin/debut"]

end
