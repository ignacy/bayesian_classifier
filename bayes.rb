class Array
  def sum
    self.inject(:+)
  end
end

class Bayes
  attr_reader :dictionary, :vectors, :classes

  # Creates new Bayesian clasiffier.
  #
  # Lets say that we have a vector of data extracted from emails that
  # looks like this (this example of course if to small to build a workign
  # clasiffier - to do that we would need many more emails):
  #
  # v = [
  #   ["Dear", "John", "Thank", "you", "for", "the", "invitation"],
  #   ["Hey", "you", "should", "buy", "viagra!!"]
  # ]
  #
  # And we want to build a clasiffier that will filter out emails like the second
  # one. To do that we can say that the first email is ok so has for example
  # class = 1, and the second one is a spam and it's class is equal to 0.
  #
  # This would mean that *v*:: would be our vector and classes would be [1, 0]
  # we would also need a dictionary of all possible words, which would be a set
  # of all words in all emails, created by the code below from *v*::
  #
  # _Parameters_::
  # +dictionary+:: array(s) of words that are treated by the clasiffier as valid
  # +vector+:: list of N lists of text that we use to train the clasiffier
  # +classes+:: list of N classes that correspond to postions in vector
  def initialize(dictionary, vectors, classes)
    @dictionary = dictionary.flatten.uniq
    @vectors    = build_vectors(vectors)
    @classes    = classes
  end

  # Returns an array of 0 and 1. For every index of returned
  # array 0 means that the word at the same index of +words+:: array
  # is not present in the dictionary set and 1 means it is present.
  def words_in_the_dictionary(words)
    matches = Array.new(dictionary.size) { 0 } # initialize with 0
    words.each do |word|
      matches[dictionary.index(word)] = 1 if dictionary.include?(word)
    end
    matches
  end

  def train
    p_that_belongs = classes.sum.to_f / classes.length

    p1, p0 = initialize_probabilities(vectors.first.size)
    p1_total, p0_total = 2.0, 2.0 # for lower bias

    vectors.each_with_index do |v, i|
      if classes[i] == 1
        v.each_with_index do |val, inx|
          p1[inx] += val
        end
        p1_total += v.sum
      else
        v.each_with_index do |val, inx|
          p0[inx] += val
        end
        p0_total += v.sum
      end
    end

    p1_vector = conditional_probs(p1, p1_total)
    p0_vector = conditional_probs(p0, p0_total)

    return p0_vector, p1_vector, p_that_belongs
  end

  def classify(example, p0Vec, p1Vec, pClass1)
    for_1 = []
    for_0 = []

    example.each_with_index do |val, i|
      for_1[i] = val * p1Vec[i]
      for_0[i] = val * p0Vec[i]
    end

    p1 = for_1.sum + pClass1
    p0 = for_0.sum + 1.0 - pClass1
    (p1 > p0) ? 1 : 0
  end

  private

  def build_vectors(data)
    data.each.inject([]) do |vs, post|
      vs << words_in_the_dictionary(post)
    end
  end

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
