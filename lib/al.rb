class Al
  def initialize(default = nil)
    @languages = { DEFAULT => default }
  end

  def []=(tag, val)
    tag = preprocess(tag)

    tag.split(DASH).each_with_object("") do |bit, key|
      key.concat("-#{bit}")
      @languages[key[1..-1]] ||= val
    end

    @languages[tag] = val # ensure xx overwrites a previous xx-yy
  end

  def [](tag)
    @languages[preprocess(tag)]
  end

  def pick(header)
    high = 0.0
    best = nil

    preprocess(header).split(COMMA).each do |tag|
      len = tag.size
      sem = tag.index(SEMICOLON) || len
      pos = sem
      
      while pos
        attempt = tag[0, pos]
        result  = @languages[attempt]

        if result
          quality = quality(tag, sem, len)

          if quality > high
            high = quality
            best = result
            break
          end
        end

        pos = tag.rindex(DASH, -(len - pos) - 1)
      end
    end

    return best || @languages[DEFAULT]
  end

  def strict_pick(header)
    high = 0.0
    best = nil

    preprocess(header).split(COMMA).each do |tag|
      sem    = tag.index(SEMICOLON) || tag.size
      result = @languages[tag[0, sem]]

      if result
        len     = tag.size
        sem     = tag.index(SEMICOLON) || len
        quality = quality(tag, sem, len)

        if quality > high
          high = quality
          best = result
          next
        end
      end
    end

    return best || @languages[DEFAULT]
  end

  private

  WHITESPACE = /\s+/.freeze
  EMPTY      = "".freeze

  def preprocess(s)
    result = s.downcase
    result.gsub!(WHITESPACE, EMPTY)

    return result
  end

  def quality(tag, sem, len)
    q       = tag[sem + 3, 10]
    quality = q ? Float(q) : 1.0
  rescue ArgumentError
    quality = 0.0
  end

  DEFAULT   = "*".freeze
  COMMA     = ",".freeze
  SEMICOLON = ";".freeze
  DASH      = "-".freeze
end
