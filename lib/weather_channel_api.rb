class WeatherChannelAPI
  # Validate incoming params
  def pre_transform_validation
    # Nothing needed for this. Empty object. Entry path.
    # Or... credentials/api key?
  end

  # Validate what is being sent to the next worker
  def post_transform_validation
    # Anything consuming from this can expect the following:
      # Object containing
        # temp_f: Float
        # wind_mph: Float
  end

  def transform
    # Makes request with credentials

  end
end
