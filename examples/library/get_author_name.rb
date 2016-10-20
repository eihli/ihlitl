require_relative '../../lib/exceptions'
require_relative '../../lib/fulfillment_agent'

class GetAuthorName < IhliTL::FulfillmentAgent
  attr_reader :error

  def email_address_mappings
    {
      'foo@example.com': 'Foo McFooerson',
      'bar@example.com': 'Bar McBar',
      'baz@example.com': 'Baz McBaz'
    }
  end

  def initialize(email_address)
    @email_address = email_address
    @error = nil
  end

  def fulfill(subject)
    subject[:name] = email_address_mappings[@email_address.to_sym]
    subject
  rescue => e
    @error = IhliTL::FulfillmentError.new self, subject, e
  end
end
