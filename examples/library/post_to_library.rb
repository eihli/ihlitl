require_relative '../../lib/exceptions'

class PostToLibrary
  attr_reader :error

  def initialize(api_key)
    @api_key = api_key
    @error
  end

  def fulfill(subject)
    response = post_data_to_library_api(subject)
    # We may accessing user inputted values here and need to rescue
    # StandardErrors and gracefully handle
    rescue => e
    @error = IhliTL::FulfillmentError.new self, subject, e
    ensure
    subject
  end

  private

  def post_data_to_library_api(subject)
    response = {}
    # Let's pretend we made an API call and the response was
    # dependent on some value in our request payload
    if @api_key == '12345' && subject[:name] != nil
      subject[:library_response_code] = '201'
    else
      subject[:library_response_code] = '404'
    end
    subject
  end
end
