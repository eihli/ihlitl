require 'minitest/autorun'
require_relative '../lib/clause'

class ClauseTest < MiniTest::Test
  def setup
    @subject = {}
    @description = 'Clause description'
    @options = {}
  end

  def test_verify_returns_errors_if_evaluates_to_false
    option = {
      accessor: '[]',
      property: 'prop',
      comparator: '==',
      value: '5'
    }
    subject = { prop: '6' }

    clause = Clause.new subject, @description, [option]
    errors = clause.verify
    assert_equal errors[0], "Error: expected #{option[:comparator]}, #{subject[:prop]}, #{option[:value]} with subject #{subject}"
  end

  def test_verify_returns_true_if_evaluates_to_true
    option = {
      accessor: '[]',
      property: 'prop',
      comparator: '==',
      value: '5'
    }
    subject = { prop: '5' }

    clause = Clause.new subject, @description, [option]
    assert_equal clause.verify, true
  end

  def test_verify_captures_exceptions
    option = {
      accessor: 'invalid_accessor',
      property: 'prop',
      comparator: '==',
      value: '5'
    }
    subject = { existant_prop: '5' }

    clause = Clause.new subject, @description, [option]
    errors = clause.verify
    assert_equal errors[0].class, NoMethodError
  end
end
