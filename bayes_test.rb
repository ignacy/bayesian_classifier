require 'minitest/autorun'
require_relative 'bayes'

class BayesTest < MiniTest::Unit::TestCase
  def setup_full_test
    @dataSet = [
                ['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'],
                ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
                ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
                ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
                ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop','him'],
                ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid']
               ]

    @bayes = Bayes.new(@dataSet, @dataSet, [0, 1, 0, 1, 0, 1])
    @p0, @p1, @p_belongs =  @bayes.train
  end

  def test_makes_unique_vocabulary
    dict = [["this", "is", "are"], ["this", "are", "plums"]]
    bayes = Bayes.new dict, dict, []
    assert_equal ["this", "is", "are", "plums"], bayes.dictionary
  end

  def test_matches_against_vocabulary
    dict = [["this", "this", "is", "something", "huge"]]
    bayes = Bayes.new dict, dict, []
    text = ["this", "was", "a", "very", "huge", "deal"]
    assert_equal [1, 0, 0, 1], bayes.words_in_the_dictionary(text)
  end

  def test_trains_naive_bayesian_classifier
    post1 = ["this", "huge", "deal"]
    post2 = ["offensive", "dick", "penis"]
    post3 = ["something", "penis", "other"]
    set = [post1, post2, post3]

    bayes = Bayes.new(set, set, [0, 1, 1])
    p0, p1, p_belongs =  bayes.train
    assert_equal 2.0/3, p_belongs
    assert_equal 8, p0.size
    assert_equal [0.0, 0.0, 0.0, 0.125, 0.125, 0.25, 0.125, 0.125], p1
  end

  def test_classifying_real_data_spam
    setup_full_test
    guesed = @bayes.classify(@bayes.words_in_the_dictionary(["stupid", "garbage"]),
                             @p0, @p1, @p_belongs)
    assert_equal 1, guesed
  end

  def test_classifying_real_data_non_spam
    setup_full_test
    guesed = @bayes.classify(@bayes.words_in_the_dictionary(["love", "butterfly"]),
                             @p0, @p1, @p_belongs)
    assert_equal 0, guesed
  end
end
