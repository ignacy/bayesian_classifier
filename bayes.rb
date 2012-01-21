class Bayes
  attr_accessor :vocabulary
  
  def vocabularize(set)
    @vocabulary = set.flatten.uniq
  end

  def matches_vector(text)
    text.inject([]) do |matches, word|
      matches << (@vocabulary.include?(word) ? 1 : 0)
    end
  end
  
  
end
