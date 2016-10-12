require 'minitest/autorun'

class BooleanTest < Minitest::Test
  def test_odd
    assert 2.odd?, 'value is not odd'
  end
end