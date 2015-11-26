require "al"
require "cutest"
require "securerandom"

test "no input" do
  al = Al.new("en-gb", "british english")

  assert_equal al.strict_pick(nil), ["en-gb", "british english"]
end

test "case sensitivity" do |al|
  al = Al.new
  al["dA"]    = 1
  al["en-GB"] = 2
  al["En"]    = 3
  
  assert_equal al.strict_pick("da, en-gb;q=0.8, en;q=0.7"), ["da", 1]
  assert_equal al.strict_pick("Da;Q=0.1, EN-gb;q=0.3, eN;q=0.2"), ["en-gb", 2]
end

test "spaces" do
  al = Al.new
  al["da"]    = 1
  al["en-gb"] = 2
  al["en"]    = 3

  assert_equal al.strict_pick("da,en-gb;q=0.8,en;q=0.7"), ["da", 1]
  assert_equal al.strict_pick("da;q=0.1,en-gb;q=0.3,en;q=0.2"), ["en-gb", 2]

  al = Al.new
  al["da"]    = 1
  al["en-gb"] = 2
  al["en"]    = 3

  assert_equal al.strict_pick("da, en-gb;q =0.8,en ;   q= 0.7"), ["da", 1]
  assert_equal al.strict_pick("da;q=0.1,en - gb ;q= 0. 3, e n;q=0.2"), ["en-gb", 2]
end

test "no language tags" do
  al = Al.new
  al["da"] = 2

  assert_equal al.strict_pick(";q=0.8, da;q=0.7"), ["da", 2]
end

test "numeric sub tags" do
  al = Al.new
  al["es-419"] = "latin american spanish"

  assert_equal al.strict_pick("es-419;q=0.7"), ["es-419", "latin american spanish"]
end

test "invalid quality values" do
  al = Al.new
  al["en-gb"] = "british english"
  al["en-us"] = "american english"

  assert_equal al.strict_pick("en-gb;q, en-us;q=0.8"), ["en-gb", "british english"]
  assert_equal al.strict_pick("en-gb;q=, en-us;q=0.8"), ["en-us", "american english"]
  assert_equal al.strict_pick("en-gb;q=., en-us;q=0.8"), ["en-us", "american english"]
  assert_equal al.strict_pick("en-gb;q=.9, en-us;q=0.8"), ["en-gb", "british english"]
  assert_equal al.strict_pick("en-gb;q=aaa, en-us;q=0.8"), ["en-us", "american english"]
end

test "gibberish" do
  al = Al.new("en-gb", "british english")

  assert 1000.times.all? {
    s = SecureRandom.random_bytes rand(1000)
    
    al.strict_pick(s) || raise("failed on: #{s}")
  }
end
