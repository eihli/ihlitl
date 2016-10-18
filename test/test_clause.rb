require 'minitest/autorun'
require_relative '../lib/clause'
require_relative '../lib/exceptions'

class ClauseTest < MiniTest::Test
  def setup
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

    clause = IhliTL::Clause.new @description, [option]
    errors = clause.verify(subject)
    assert_equal "Error: expected #{option[:comparator]}, #{option[:value]}, #{subject[:prop]} with #{subject}", errors[0].message
  end

  def test_verify_returns_empty_list_if_true
    option = {
      accessor: '[]',
      property: 'prop',
      comparator: '==',
      value: '5'
    }
    subject = { prop: '5' }

    clause = IhliTL::Clause.new @description, [option]
    assert_equal clause.verify(subject), []
  end

  def test_verify_captures_exceptions
    option = {
      accessor: 'invalid_accessor',
      property: 'prop',
      comparator: '==',
      value: '5'
    }
    subject = { existant_prop: '5' }

    clause = IhliTL::Clause.new @description, [option]
    errors = clause.verify(subject)
    assert_equal errors[0].class, IhliTL::ClauseError
    assert_equal errors[0].message, "undefined method `invalid_accessor' for {:existant_prop=>\"5\"}:Hash"
  end
end
