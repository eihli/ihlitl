require_relative '../../lib/clause'

class FingerprintClause < IhliTL::Clause
  def initialize(description = 'Fingerprint Clause', options = [])
    super
    if options.length == 0
      options = [
        {
          property: 'fingerprint',
          accessor: '[]',
          attribute: 'length',
          comparator: '>',
          value: 5
        },
        {
          property: 'fingerprint',
          accessor: '[]',
          attribute: 'length',
          comparator: '<',
          value: 20
        }
      ]
    end
    @options = options
  end
end
