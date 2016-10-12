require 'minitest/autorun'
require_relative '../lib/destination'

class TestDestination < MiniTest::Test
  def setup
    @validator = Object.new
    def @validator.validate(payload); end;
  end

  def test_run_with_valid_payload
    @validator.stub :validate, true do
      assert Destination.run('some_payload', @validator) == true
    end
  end

  def test_run_with_invalid_payload
    @validator.stub :validate, false do
      assert Destination.run('some_payload', @validator) == false
    end
  end
end
