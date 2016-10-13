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
end
