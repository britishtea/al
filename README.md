# Al

Al stands for `Accept-Language`

## What does Al do?

Al picks the best match from an `Accept-Language` header given a set of 
available languages.

* Al respects quality values
* Al respects language tag prefixes
* Al ignores character case
* Al ignores spaces (but not other whitespace)
* Al makes an effort to put up with invalid `Accept-Language` headers
* Al is fast!

## Usage

```ruby
# Define the available languages and their values
al          = Al.new(:greeting => "Hello")
al["en-GB"] = { :greeting => "How do you do?" }
al["en-US"] = { :greeting => "Howdy partner!" }
al["en"]    = { :greeting => "Hi" }

# Let Al make a sensible match
match = al.pick("de-DE;q=0.5, de-AT;q=0.4, en-AU")
match[:greeting] # => "Hello"

match = al.pick("en-AU;q=0.4, en-US:q=0.5")
match[:greeting] # => "Howdy!"

match = al.pick("da")
match[:greeting] # => "Hello"
```

The default language is optional. Without a default language Al returns `nil` 
if it can't find a match.

## Al and [RFC 2616]

RFC 2616 says a more specific language tag than the requested language tag can
be used if an exactly matching language tag is not available. The reverse is
illegal. This means that `en` is not a match when `en-GB` is requested, but 
`en-GB` is a match when `en` is requested.

Al thinks this is silly.

The `#pick` method will ignore this rule and treat `en` as a valid match when
`en-GB` is requested. It otherwise follows RFC 2616. A `#strict_pick` method is 
provided which follows RFC 2616 exactly.

[RFC 2616]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html

## Installation

`gem install al`

## Tests

To be able to run the tests install Al with development dependencies (`gem
install al --development`). Then run `rake test`.

## License

See the LICENSE file.
