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
#                #pick    20.497k i/100ms
#         #strict_pick    16.722k i/100ms
# http_accept_language     1.959k i/100ms
# -------------------------------------------------
#                #pick    246.558k (± 3.4%) i/s -      1.250M
#         #strict_pick    195.797k (± 3.2%) i/s -    986.598k
# http_accept_language     20.158k (± 2.5%) i/s -    101.868k
#
# Worst case (matching tag with q=1.0 in last position):
#
# Calculating -------------------------------------
#                #pick    10.861k i/100ms
#         #strict_pick    16.644k i/100ms
# http_accept_language     1.976k i/100ms
# -------------------------------------------------
#                #pick    119.696k (± 3.2%) i/s -    608.216k
#         #strict_pick    193.883k (± 4.0%) i/s -    981.996k
# http_accept_language     19.359k (± 5.6%) i/s -     96.824k

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
