Gem::Specification.new do |s|
  s.name        = "bugger"
  s.version     = "0.1.0"
  s.licenses    = ["MIT"]
  s.summary     = "Tiny Rack middleware for exception notifications"
  s.description = "Al picks the best match from an `Accept-Language` header " \
                  "given a set of available languages."
  s.authors     = ["Jip van Reijsen"]
  s.email       = "jipvanreijsen@gmail.com"
  s.files       = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.test_files  = Dir["test/*.rb"]

  s.add_development_dependency "cutest", "~> 1.2", ">= 1.2.2"
end
