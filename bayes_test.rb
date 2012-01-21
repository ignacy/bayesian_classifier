require 'test/unit'
require_relative 'bayes'

class BayesTest < Test::Unit::TestCase
  def setup
    @dataSet = [
                ['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'],
                ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
                ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
                ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
                ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop','him'],
                ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid']
               ]
    @classes = [0, 1, 0, 1, 0, 1] # 1 spam, 0 not spam
    @bayes = Bayes.new
  end

  def test_makes_unique_vocabulary
    assert_equal ["this", "is", "are", "plums"],
      @bayes.vocabularize([["this", "is", "are"], ["this", "are", "plums"]])
  end

  def test_matches_against_vocabulary
    @bayes.vocabularize(["this", "this", "is", "something", "huge"])
    text = ["this", "was", "a", "very", "huge", "deal"]
    assert_equal [1, 0, 0, 0, 1, 0],
      @bayes.matches_vector(text)
  end
  

end
