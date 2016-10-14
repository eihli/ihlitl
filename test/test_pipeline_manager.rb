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

  def test_a_single_transform_with_args
    destination = Object.new
    some_args = [1, 2]
    mock = MiniTest::Mock.new
    mock.expect :new, destination, some_args

    transforms = [[mock, *some_args]]
    pipeline = PipelineManager.new transforms, {}
    mock.verify

    assert_equal pipeline.transforms[0], destination
  end

  def test_multiple_transforms_with_no_args
    transform_mock = MiniTest::Mock.new
    destination_mock = MiniTest::Mock.new

    transform = Object.new
    destination = Object.new

    transform_mock.expect :new, transform, [destination]
    destination_mock.expect :new, destination

    transforms = [[transform_mock], [destination_mock]]
    pipeline = PipelineManager.new transforms, {}

    transform_mock.verify
    destination_mock.verify

    assert_equal pipeline.transforms, [transform, destination]
  end

  def test_multiple_transforms_with_args
    transform_mock = MiniTest::Mock.new
    destination_mock = MiniTest::Mock.new

    transform = Object.new
    transform_args = [1, 2]
    destination = Object.new
    destination_args = ['some', 'args']

    transform_mock.expect :new, transform, [destination, *transform_args]
    destination_mock.expect :new, destination, [*destination_args]

    transforms = [
      [transform_mock, *transform_args],
      [destination_mock, *destination_args]
    ]
    pipeline = PipelineManager.new transforms, {}

    transform_mock.verify
    destination_mock.verify
  end
end

