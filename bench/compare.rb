require "al"
require "benchmark/ips"
require "http_accept_language"

# This benchmark compares Al's #pick, #strict_pick and the popular library
# http_accept_language. Al's #pick is equivalent to http_accept_language in this
# benchmark, #strict_pick should not be compared with http_accept_language.
#
# This benchmark simulates what is strictly needed in an application to pick a
# matching language. This is why Al can get away with a single instance and
# http_accept_language needs a new instance for every iteration.
#
# To run this benchmark, you need to install two gems. These are not listed as
# development dependencies.
#
#   gem install benchmark-ips http_accept_language
#
# Output for a single run on a random machine:
#
# $ ruby -I lib bench/compare.rb
# Calculating -------------------------------------
#                #pick    11.175k i/100ms
#         #strict_pick    16.769k i/100ms
# http_accept_language     1.942k i/100ms
# -------------------------------------------------
#                #pick    121.816k (± 3.4%) i/s -    614.625k
#         #strict_pick    192.529k (± 4.0%) i/s -    972.602k
# http_accept_language     20.319k (± 3.0%) i/s -    102.926k

al = Al.new
al["en"] = "british english"

Benchmark.ips do |x|
  x.report("#pick") do
    al.pick("xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL, en-gb")
  end

  x.report("#strict_pick") do
    al.strict_pick("xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL, en-gb")
  end

  x.report("http_accept_language") do
     hal = HttpAcceptLanguage::Parser.new("xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL, en-gb")
     hal.compatible_language_from([:en])
  end
end
