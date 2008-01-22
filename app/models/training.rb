class Training < ActiveRecord::Base
  belongs_to :team
  
  validates_length_of        :location,    :maximum => 300
  validates_length_of        :summary,    :maximum => 700, :allow_nil=>true
  
  def before_create
    self.summary = '' if self.summary==nil
    self.start_time = DateTime.now if self.start_time==nil
    self.end_time = DateTime.now if self.end_time==nil
  end
end
