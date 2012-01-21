class Bayes
  attr_accessor :vocabulary

  def vocabularize(set)
    @vocabulary = set.flatten.uniq
  end

  def matches_vector(text)
    matches = []
    @vocabulary.size.times { matches << 0 }
    text.each do |word|
      if @vocabulary.include?(word)
        matches[@vocabulary.index(word)] = 1
      end
    end
    matches
  end

  def vectors(set)
    vectors = set.each.inject([]) do |vectors, post|
      vectors << matches_vector(post)
    end
  end


  def train(vectors, classes)
    p_belongs = classes.inject(:+).to_f / classes.length

    p1, p0 = [], []

    vectors.first.size.times do
      p1 << 0
      p0 << 0
    end

    
    p1_den, p0_den = 0.0, 0.0
    vectors.each_with_index do |v, i|
      if classes[i] == 1
        p1[i] += v[i]
        p1_den += v.inject(:+)
      else
        p0[i] += v[i]
        p0_den += v.inject(:+)
      end
    end

    p1_vector = p1.inject([]) do |result, value|
      result << (value.to_f / p1_den)
    end

    p0_vector = p0.inject([]) do |result, value|
      result << (value.to_f / p0_den)
    end

    return p0_vector, p1_vector, p_belongs
  end

end
