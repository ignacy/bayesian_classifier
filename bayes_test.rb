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
    @bayes.vocabularize(@dataSet)
    @p0, @p1, @p_belongs =  @bayes.train(@bayes.vectors(@dataSet), @classes)
  end

  def test_makes_unique_vocabulary
    assert_equal ["this", "is", "are", "plums"],
    @bayes.vocabularize([["this", "is", "are"], ["this", "are", "plums"]])
  end

  def test_matches_against_vocabulary
    @bayes.vocabularize(["this", "this", "is", "something", "huge"])
    text = ["this", "was", "a", "very", "huge", "deal"]
    assert_equal [1, 0, 0, 1],
    @bayes.matches_vector(text)
  end

  def test_trains_naive_bayesian_classifier
    post1 = ["this", "huge", "deal"]
    post2 = ["offensive", "dick", "penis"]
    post3 = ["something", "penis", "other"]
    set = [post1, post2, post3]
    @bayes.vocabularize(set)
    classes = [0, 1, 1]
    p0, p1, p_belongs =  @bayes.train(@bayes.vectors(set), classes)
    assert_equal 2.0/3, p_belongs
    assert_equal 8, p0.size
  end

  def test_classifying_real_data_spam
    guesed = @bayes.classify(@bayes.matches_vector(["stupid", "garbage"]),
                             @p0, @p1, @p_belongs)
    assert_equal 1, guesed
  end

  def test_classifying_real_data_non_spam
    guesed = @bayes.classify(@bayes.matches_vector(["love", "butterfly"]),
                             @p0, @p1, @p_belongs)
    assert_equal 0, guesed
  end
end
