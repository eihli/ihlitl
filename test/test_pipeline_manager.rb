require 'minitest/autorun'
require_relative '../lib/helpers'
require_relative '../lib/pipeline_manager'

class TestPipelineManager < MiniTest::Test
  def setup
  end

  def test_run_calls_transform_on_each_pipeline_item
    mock_transforms = Array.new(3).map do |t|
      mock = MiniTest::Mock.new
      mock.expect :run, Hash.new, [Hash]
      [mock]
    end

    PipelineManager.pipeline = mock_transforms
    PipelineManager.run
    mock_transforms.each do |m|
      m[0].verify
    end
  end

  def test_run_calls_deliver_with_transformed_payload
    payload = {}
    keys = [:a, :b, :c]
    value = 0
    mock_transforms = Array.new(3).map do |t|
      transformed_payload = deep_copy payload
      transformed_payload[keys[value]] = value
      value += 1

      mock = MiniTest::Mock.new
      mock.expect :run, transformed_payload, [payload]

      payload = transformed_payload
      [mock]
    end

    PipelineManager.pipeline = mock_transforms

    mock = MiniTest::Mock.new
    mock.expect :call, nil, [{a: 0, b: 1, c: 2}]
    PipelineManager.stub :deliver, mock do
      PipelineManager.run
    end

    mock.verify
  end
end
