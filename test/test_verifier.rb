require 'minitest/autorun'
require_relative '../lib/verifier'

class TestVerifier < MiniTest::Test
  def setup
    @assertion = {
      msg_chain: [:[]],
      args: [[:key]],
      comparator: '==',
      value: 'value'
    }
  end

  def test_verify_returns_true_on_success
    verifier = IhliTL::Verifier
    subject = {key: 'value'}
    assert_equal true, verifier.verify(@assertion, subject)
  end
end
