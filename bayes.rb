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


    p1_den, p0_den = 2.0, 2.0
    vectors.each_with_index do |v, i|
      if classes[i] == 1
        v.each_with_index do |val, inx|
          p1[inx] += val
        end
        p1_den += v.inject(:+)
      else
        v.each_with_index do |val, inx|
          p0[inx] += val
        end
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

  def classify(example, p0Vec, p1Vec, pClass1)
    for_1 = []
    for_0 = []
    
    example.each_with_index do |val, i|
      for_1[i] = val * p1Vec[i]
      for_0[i] = val * p0Vec[i]
    end
    
    p1 = for_1.inject(:+) + pClass1
    p0 = for_0.inject(:+) + 1.0 - pClass1
    (p1 > p0) ? 1 : 0
  end

end
