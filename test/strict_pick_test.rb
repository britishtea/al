require "al"
require "cutest"

test "exact match" do
  al = Al.new
  al["en-gb"] = "british english"

  assert_equal al.strict_pick("en-gb"), ["en-gb", "british english"]
end

test "less specific match" do
  al = Al.new
  al["en"] = "english"

  assert_equal al.strict_pick("en-gb"), [nil, nil]
end

test "more specific match" do
  al = Al.new
  al["en-gb"] = "british english"

  assert_equal al.strict_pick("en"), ["en-gb", "british english"]
end

test "quality values" do |al|
  al = Al.new
  al["da"]    = "danish"
  al["en-gb"] = "british english"
  al["en"]    = "english"

  assert_equal al.strict_pick("da, en-gb;q=0.8, en;q=0.7"), ["da", "danish"]
  assert_equal al.strict_pick("da;q=0.1, en-gb;q=0.3, en;q=0.2"), ["en-gb", "british english"]
end

test "default value" do
  al = Al.new

  assert_equal al.strict_pick("*"), [nil, nil]
  assert_equal al.strict_pick("da"), [nil, nil]
  
  al = Al.new("en", "english")

  assert_equal al.strict_pick("*"), ["en", "english"]
  assert_equal al.strict_pick("da"), ["en", "english"]
end
