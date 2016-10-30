require_relative '../../lib/exceptions'
require_relative '../../lib/fulfillment_agent'

class GetAuthorName < IhliTL::FulfillmentAgent
  attr_reader :error

  def email_address_mappings
    {
      'foo@example.com': {
        'name': 'Foo McFooerson',
        'age': '25'
      },
      'bar@example.com': {
        'name': 'Bar McBar',
        'age': '33'
      },
      'baz@example.com': {
        'name': 'Baz McBaz',
        'age': '44'
      }
    }
  end

  def initialize(email_address)
    @email_address = email_address
    @error = nil
  end

  def fulfill(subject)
    subject[:name] = email_address_mappings[@email_address.to_sym][:name]
    subject
  rescue => e
    @error = IhliTL::FulfillmentError.new self, subject, e
  ensure
    subject
  end
end
