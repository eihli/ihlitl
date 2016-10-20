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

  def test_verify_returns_errors
    verifier = IhliTL::Verifier
    subject = {key: 'wrong_value'}
    error_msg = "Error: {:key=>\"wrong_value\"}, [:[]], [[:key]], ==, value"
    assert_equal error_msg, verifier.verify(@assertion, subject)
  end
end
