require_relative '../lib/transform'
require_relative '../lib/contract'

class WeatherContract < IhliTL::Contract
  def initialize(subject, transform)
    @subject = subject
    @transform = transform
  end

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
  def initialize(subject, transform)
    @subject = subject
    @transform = transform
  end

  def clauses
    [
      -> (subject) { zip_code_clause(subject) }
    ]
  end

  def zip_code_clause(subject)
    Integer(subject[:zip_code]) &&
      subject[:zip_code].length == 5
  end
end

class ZipCodeTransform < IhliTL::Transform
  def transform(payload)
    payload[:zip_code] = '90210'
    payload
  end
end

class WeatherTransform < IhliTL::Transform
  def transform(payload)
    payload = ZipCodeContract.new(payload, -> (payload) {
      ZipCodeTransform.new.transform(payload)
    }).resolve

    payload[:temp_f] = '5'
    payload
  end
end

foo = WeatherContract.new({}, -> (payload) {
  WeatherTransform.new.transform({})
})
puts foo.resolve
