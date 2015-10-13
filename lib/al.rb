class Al
  def initialize(tag = nil, val = nil)
    @languages = { DEFAULT => [tag, val] }

    if tag && val
      self[tag] = val
    end
  end

  def []=(tag, val)
    tag = preprocess(tag)

    tag.split(DASH).each_with_object("") do |bit, key|
      key.concat("-#{bit}")
      @languages[key[1..-1]] ||= [tag, val]
    end

    @languages[tag] = [tag, val] # ensure xx overwrites a previous xx-yy
  end

  def [](tag)
    @languages[preprocess(tag)][1]
  end

  def pick(header)
    unless header
      return @languages[DEFAULT]
    end

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
    unless header
      return @languages[DEFAULT]
    end

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

  SPACE = " ".freeze
  EMPTY = "".freeze

  def preprocess(s)
    result = s.tr(SPACE, EMPTY)
    result.downcase!

    return result
  end

  def quality(tag, sem, len)
    q = tag[sem + 3, 10]

    return q ? Float(q) : 1.0
  rescue ArgumentError
    0.0
  end

  DEFAULT   = "*".freeze
  COMMA     = ",".freeze
  SEMICOLON = ";".freeze
  DASH      = "-".freeze
end
