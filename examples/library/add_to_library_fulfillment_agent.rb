require_relative '../../lib/exceptions'

class AddToLibraryFulfillmentAgent
  attr_reader :error

  def initialize(library_credentials)
    @credentials = library_credentials
    @error
  end

  def fulfill(subject)
    if @credentials == 'password' && subject[:name] != nil
      subject[:library_response_code] = '201'
    else
      subject[:library_response_code] = '404'
    end
  rescue => e
    @error = IhliTL::FulfillmentError.new self, subject, e
  end
end
