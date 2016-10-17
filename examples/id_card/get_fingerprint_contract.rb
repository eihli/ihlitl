require_relative '../../lib/contract'
require_relative './fingerprint_clause'

class FingerprintGetContract < IhliTL::Contract
end

f = FingerprintGetContract.new(nil, [FingerprintClause.new])

puts f.resolve({fingerprint: 'aasdfa'})
