class Al
  def initialize(tag = nil, value = nil)
    @languages = { "*" => [tag, value] }

    if tag && value
      self[tag] = value
    end
  end

  def []=(tag, value)
    tag = preprocess(tag)

    tag.split("-").inject do |key, bit|
      @languages[key] ||= [tag, value]
      "#{key}-#{bit}"
    end

    @languages[tag] = [tag, value] # ensure xx overwrites a previous xx-yy
  end

  def [](tag)
    @languages[preprocess(tag)][1]
  end

  def pick(header)
    find(header) do |tag|
      length = tag.length
      dash_index = length
      
      while dash_index
        result = @languages[tag[0, dash_index]]

        if result
          break result
        end

        dash_index = tag.rindex("-".freeze, dash_index - length - 1)
      end
    end
  end

  def strict_pick(header)
    find(header) { |tag| @languages[tag] }
  end

  private

  def find(header, &block)
    best_quality = 0.0
    best_result = nil

    preprocess(header.to_s).split(",".freeze).each do |language_range|
      tag, q = language_range.split(";".freeze, 2)

      unless tag
        next
      end

      result = yield(tag)

      unless result
        next
      end

      quality = quality(q)

      if quality > best_quality
        best_quality = quality
        best_result = result

        if quality >= 1.0
          break result
        end
      end
    end

    return best_result || @languages["*".freeze]
  end

  def preprocess(header)
    result = header.delete(" ".freeze)
    result.downcase!

    return result
  end

  def quality(q)
    if q.nil? || q.size < 2
      return 1.0
    end

    return q[2, 10].to_f
  end
end
