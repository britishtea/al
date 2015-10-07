require "al"
require "cutest"

test "exact match" do
  al = Al.new
  al["en-gb"] = "british english"

  assert_equal al.pick("en-gb"), "british english"
end

test "less specific match" do
  al = Al.new
  al["en"] = "english"

  assert_equal al.pick("en-gb"), "english"
end

test "more specific match" do
  al = Al.new
  al["en-gb"] = "british english"

  assert_equal al.pick("en"), "british english"
end

test "quality values" do |al|
  al = Al.new
  al["da"]    = "danish"
  al["en-gb"] = "british english"
  al["en"]    = "english"

  assert_equal al.pick("da, en-gb;q=0.8, en;q=0.7"), "danish"
  assert_equal al.pick("da;q=0.1, en-gb;q=0.3, en;q=0.2"), "british english"
end

test "default value" do
  al = Al.new

  assert_equal al.pick("*"), nil
  assert_equal al.pick("da"), nil
  
  al = Al.new("default")

  assert_equal al.pick("*"), "default"
  assert_equal al.pick("da"), "default"
end
