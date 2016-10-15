require 'minitest/autorun'
require_relative '../lib/contract'

class TestContract < MiniTest::Test
  def setup
    @subject = { name: 'some name' }
    @contract = IhliTL::Contract.new(@subject)
  end

  def test_resolve_method_returns_passed_in_subject
    assert_equal @contract.resolve, @subject
  end

  def test_resolve_calls_verify
    mock = MiniTest::Mock.new
    mock.expect :call, nil
    @contract.stub :verify, mock do
      @contract.resolve
    end
    mock.verify
  end
end
