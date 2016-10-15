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
    mock.expect :call, nil, [@subject]
    @contract.stub :verify, mock do
      @contract.resolve
    end
    mock.verify
  end

  def test_verify_calls_perform_work
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [@subject]
    @contract.stub :perform_work, mock do
      @contract.resolve
    end
    mock.verify
  end

  def test_resolve_runs_each_clause
    mock1 = MiniTest::Mock.new
    mock1.expect :call, nil, [@subject]
    mock2 = MiniTest::Mock.new
    mock2.expect :call, nil, [@subject]

    clauses = [mock1, mock2]
    @contract.stub :clauses, clauses do
      @contract.resolve
    end

    mock1.verify
    mock2.verify
  end
end
