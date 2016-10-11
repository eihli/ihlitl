class WeatherChannelToTwitterPipelineManager
  def pipeline
    {
      source: WeatherChannelAPI,
      transforms: [
        MakeItCold,
        MakeItWindy
      ],
      destination: TwitterAPI
    }
  end


end
