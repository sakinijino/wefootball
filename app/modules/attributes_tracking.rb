module AttributesTracking
  def self.included(base) # hack by include   
    base.extend(ClassMethods)
    base.class_eval do  
      class << self  
        alias_method_chain :instantiate, :tracking # to hack instantiate   
      end  
    end
    
    base.after_save :store_attributes
  end  
  
  module ClassMethods   
    # find函数就是调用instantiate把db columns data转成attributes的   
    def instantiate_with_tracking(record)    
      object = instantiate_without_tracking(record)   
      object.instance_variable_set("@db_attributes", object.attributes.dup)   
      object   
    end  
  end  
  
  # instant method compares db_attributes and attributes   
  def column_changed?(column)
    return false if new_record?
    db_attributes[column.to_s] != attributes[column.to_s]   
  end
  
  private   
  attr_accessor :db_attributes  
  
  def store_attributes
    @db_attributes = self.attributes.dup
  end
end
