require 'minitest/autorun'
require_relative '../lib/clause'

class ClauseTest < MiniTest::Test
  def setup
    @subject = {}
    @description = 'Clause description'
    @options = {}
  end

  def test_calls_option_accessor_on_option_property
    option = {
      accessor: '[]',
      property: 'propety',
      comparator: '=='
    }

    subject = MiniTest::Mock.new
    subject.expect option[:accessor].to_sym, nil

    clause = Clause.new subject, @description, [option]
    clause.verify
    subject.verify
  end
end
