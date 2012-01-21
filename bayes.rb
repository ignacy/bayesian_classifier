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

    p1, p0 = initialize_probabilities(vectors.first.size)
    p1_total, p0_total = 2.0, 2.0 # for lower bias

    vectors.each_with_index do |v, i|
      if classes[i] == 1
        v.each_with_index do |val, inx|
          p1[inx] += val
        end
        p1_total += v.inject(:+)
      else
        v.each_with_index do |val, inx|
          p0[inx] += val
        end
        p0_total += v.inject(:+)
      end
    end

    p1_vector = conditional_probs(p1, p1_total)
    p0_vector = conditional_probs(p0, p0_total)

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

  private

  def initialize_probabilities(size)
    spam, no_spam = [], []
    size.times { spam << 0; no_spam << 0 }
    return spam, no_spam
  end

  def conditional_probs(matches, items_sum)
    matches.inject([]) do |result, value|
      result << (value.to_f / items_sum)
    end
  end

end
