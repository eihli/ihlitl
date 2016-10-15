require 'minitest/autorun'
require_relative '../lib/helpers'
require_relative '../lib/exceptions'
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
    pipeline = IhliTL::PipelineManager.new transforms, {}
    mock.verify

    assert_equal pipeline.transforms[0], destination
  end

  def test_a_single_transform_with_args
    destination = Object.new
    some_args = [1, 2]
    mock = MiniTest::Mock.new
    mock.expect :new, destination, some_args

    transforms = [[mock, *some_args]]
    pipeline = IhliTL::PipelineManager.new transforms, {}
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
    pipeline = IhliTL::PipelineManager.new transforms, {}

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
    pipeline = IhliTL::PipelineManager.new transforms, {}

    transform_mock.verify
    destination_mock.verify
  end

  def test_run_calls_run_on_first_transform
    # This is all we need to test since the first transform
    # calls run on its destination

    transform_mock_new = MiniTest::Mock.new
    transform_mock_run = MiniTest::Mock.new

    transform_mock_new.expect :new, transform_mock_run
    payload = 'some_payload'
    transform_mock_run.expect :run, nil, [payload]

    transforms = [[transform_mock_new]]

    pipeline = IhliTL::PipelineManager.new transforms, payload
    pipeline.run
    transform_mock_run.verify
  end

  def test_calls_detour_on_exception
    transform_mock_class = Class.new
    transform_mock = Object.new
    def transform_mock.run(payload); end

    pipeline = nil
    transform_mock_class.stub :new, transform_mock do
      pipeline = IhliTL::PipelineManager.new [[transform_mock_class]], {}
    end

    err = IhliTL::TransformError.new 'payload'
    error = -> (e) { raise err }
    detour_mock = MiniTest::Mock.new
    detour_mock.expect :call, nil, [err]

    pipeline.stub :detour, detour_mock do
      transform_mock.stub :run, error do
        pipeline.run
      end
    end

    detour_mock.verify
  end
end
