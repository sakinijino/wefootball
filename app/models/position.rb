class Position < ActiveRecord::Base
  POSITIONS = %w{GK SW CB LB RB DM CM LM RM AM CF SS}
  
  validates_inclusion_of :label, :in => POSITIONS
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.position(self.label)
  end
end
