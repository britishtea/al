class Al
  def initialize(tag = nil, val = nil)
    @languages = { "*" => [tag, val] }

    if tag && val
      self[tag] = val
    end
  end

  def []=(tag, val)
    tag = preprocess(tag)

    tag.split("-").each_with_object("") do |bit, key|
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
      return @languages["*".freeze]
    end

    high = 0.0
    best = nil

    preprocess(header).split(",".freeze).each do |tag|
      len = tag.size
      sem = tag.index(";".freeze) || len
      pos = sem
      
      while pos
        attempt = tag[0, pos]
        result  = @languages[attempt]

        if result
          quality = quality(tag, sem, len)

          if quality > high
            high = quality
            best = result
            
            if high >= 1.0
              return best
            end

            break
          end
        end

        pos = tag.rindex("-".freeze, -(len - pos) - 1)
      end
    end

    return best || @languages["*".freeze]
  end

  def strict_pick(header)
    unless header
      return @languages["*".freeze]
    end

    high = 0.0
    best = nil

    preprocess(header).split(",".freeze).each do |tag|
      sem    = tag.index(";".freeze) || tag.size
      result = @languages[tag[0, sem]]

      if result
        len     = tag.size
        sem     = tag.index(";".freeze) || len
        quality = quality(tag, sem, len)

        if quality > high
          high = quality
          best = result
          
          if high >= 1.0
            return best
          end
        end
      end
    end

    return best || @languages["*".freeze]
  end

  private

  def preprocess(s)
    result = s.tr(" ".freeze, "".freeze)
    result.downcase!

    return result
  end

  def quality(tag, sem, len)
    q = tag[sem + 3, 10]

    return q ? Float(q) : 1.0
  rescue ArgumentError
    0.0
  end
end
