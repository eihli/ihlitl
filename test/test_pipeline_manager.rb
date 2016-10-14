require 'minitest/autorun'
require_relative '../lib/helpers'
require_relative '../lib/pipeline_manager'
require_relative '../lib/transform'

class TestPipelineManager < MiniTest::Test
  def setup
  end

  def test_a_single_transform_with_no_args
    mock = MiniTest::Mock.new
    destination = Object.new
    mock.expect :new, destination

    transforms = [[mock]]
    pipeline = PipelineManager.new transforms, {}
    mock.verify

    assert_equal pipeline.transforms[0], destination
  end

end

