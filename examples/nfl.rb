require_relative '../lib/transform'
require_relative '../lib/contract'

class WeatherContract < IhliTL::Contract
  def clauses
    [
      -> (subject) {
        subject[:zip_code].length == 5 &&
        Float(subject[:temp_f])
      }
    ]
  end
end

class WeatherTransform < IhliTL::Transform
  def transform(payload)
    payload.merge(ZipCodeContract.new(payload, -> (payload) {
      ZipCodeTransform.new.transform(payload)
    }).resolve)

    payload.merge(TemperatureContract.new({zip_code: '94110'}, -> (payload) {
      TemperatureTransform.new.transform(payload)
    }).resolve)
  end
end

class TemperatureContract < IhliTL::Contract
  def clauses
    [
      -> (subject) { temperature_clause(subject) }
    ]
  end

  def temperature_clause(subject)
    puts "Verifying weather"
    Float(subject[:temp_f]).class == Float
  end
end

class ZipCodeContract < IhliTL::Contract
  def clauses
    [
      -> (subject) { zip_code_clause(subject) }
    ]
  end

  def zip_code_clause(subject)
    puts "Verifying Zip Code"
    Integer(subject[:zip_code]) &&
      subject[:zip_code].length == 5
  end
end

class ZipCodeTransform < IhliTL::Transform
  def transform(payload)
    puts "Transforming Zip Code"
    payload[:zip_code] = '90210'
    payload
  end
end

class TemperatureTransform < IhliTL::Transform
  def transform(payload)
    payload = ZipCodeContract.new(payload, -> (payload) {
      ZipCodeTransform.new.transform(payload)
    }).resolve

    puts "Transforming Weather"
    payload[:temp_f] = '5'
    payload
  end
end

class OutboundTransform < IhliTL::Transform
  def transform(payload)
  end
end

foo = WeatherContract.new({}, -> (payload) {
  WeatherTransform.new.transform(payload)
})

puts foo.resolve
