module ModelHelper
  def attribute_slice(attr, length)
    self[attr] = (self[attr].chars[0...length]).to_s if !self[attr].nil? && self[attr].chars.length > length
  end
end
