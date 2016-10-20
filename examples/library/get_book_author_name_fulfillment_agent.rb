class GetBookAuthorNameFulfillmentAgent
  def initialize(email_address)
    @email_address = email_address
  end

  def fulfill(subject)
    subject[:name] = @@email_name_mappings[@email_address]
  end

  @@email_name_mappings = {
    'foo@example.com': 'Foo',
    'bar@example.com': 'Bar',
    'baz@example.com': 'Baz'
  }
end
