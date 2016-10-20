require_relative '../../lib/exceptions'

class PostToLibrary
  attr_reader :error

  def initialize(api_key)
    @api_key = api_key
    @error
  end

  def fulfill(subject)
    if @api_key == '12345' && subject[:name] != nil
      subject[:library_response_code] = '201'
    else
      subject[:library_response_code] = '404'
    end
  rescue => e
    @error = IhliTL::FulfillmentError.new self, subject, e
  end
end
