def deep_copy(hash, accum = Hash.new)
  hash.each do |key, value|
    if value.is_a? Hash
      accum[key] = deep_copy value
    else
      accum[key] = value
    end
  end
  accum
end

