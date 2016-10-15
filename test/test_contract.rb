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
    mock.expect :call, true, [@subject]
    @contract.stub :verify, mock do
      @contract.resolve
    end
    mock.verify
  end

  def test_verify_calls_perform_work
    mock = MiniTest::Mock.new
    mock.expect :call, true, [@subject]
    @contract.stub :perform_work, mock do
      @contract.resolve
    end
    mock.verify
  end

  def test_resolve_runs_each_clause
    mock1 = MiniTest::Mock.new
    mock1.expect :call, true, [@subject]
    mock2 = MiniTest::Mock.new
    mock2.expect :call, true, [@subject]

    clauses = [mock1, mock2]
    @contract.stub :clauses, clauses do
      @contract.resolve
    end

    mock1.verify
    mock2.verify
  end

  def test_resolve_raises_if_verify_is_false
    @contract.stub :verify, false do
      assert_raises do
        @contract.resolve
      end
    end
  end

  def test_verify_returns_false_if_any_clause_is_false
    false_clause = MiniTest::Mock.new
    false_clause.expect :call, false, [@subject]
    true_clause = MiniTest::Mock.new
    true_clause.expect :call, true, [@subject]

    clauses = [true_clause, false_clause]
    @contract.stub :clauses, clauses do
      assert_equal false, @contract.verify(@subject)
    end
  end

  def test_verify_returns_true_if_all_clauses_are_true
    true_clause = MiniTest::Mock.new
    true_clause.expect :call, true, [@subject]
    @contract.stub :clauses, [true_clause] do
      assert_equal true, @contract.verify(@subject)
    end
  end
end
