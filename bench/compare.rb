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
# Best case (matching tag with q=1.0 in first position):
#
# Calculating -------------------------------------
#                #pick    21.602k i/100ms
#         #strict_pick    16.547k i/100ms
# http_accept_language     2.603k i/100ms
# -------------------------------------------------
#                #pick    261.734k (± 3.3%) i/s -      1.318M
#         #strict_pick    183.094k (± 3.3%) i/s -    926.632k
# http_accept_language     26.511k (± 3.4%) i/s -    132.753k
#
# Worst case (matching tag with q=1.0 in last position):
#
# Calculating -------------------------------------
#                #pick    11.042k i/100ms
#         #strict_pick    16.341k i/100ms
# http_accept_language     2.636k i/100ms
# -------------------------------------------------
#                #pick    120.212k (± 3.0%) i/s -    607.310k
#         #strict_pick    184.948k (± 3.0%) i/s -    931.437k
# http_accept_language     27.210k (± 3.1%) i/s -    137.072k

al = Al.new
al["en"] = "british english"

puts "Best case (matching tag with q=1.0 in first position):"
puts

Benchmark.ips do |x|
  x.report("#pick") do
    al.pick("en-gb, xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL")
  end

  x.report("#strict_pick") do
    al.strict_pick("en-gb, xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL")
  end

  x.report("http_accept_language") do
    hal = HttpAcceptLanguage::Parser.new("en-gb, xx-xx-xx;q=0.5, yy-yy;q=0.4, zz;q=0.3, nl-NL")
    hal.compatible_language_from([:en])
  end
end

puts
puts "Worst case (matching tag with q=1.0 in last position):"
puts

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
