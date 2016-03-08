Gem::Specification.new do |s|
  s.name        = "al"
  s.version     = "0.1.1"
  s.licenses    = ["MIT"]
  s.summary     = "Al stands for Accept-Language"
  s.description = "Al picks the best match from an `Accept-Language` header " \
                  "given a set of available languages."
  s.authors     = ["Jip van Reijsen"]
  s.email       = "jipvanreijsen@gmail.com"
  s.homepage    = "https://github.com/britishtea/al"
  s.files       = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.test_files  = Dir["test/*.rb"]

  s.add_development_dependency "cutest", "~> 1.2", ">= 1.2.2"
end
