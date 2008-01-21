class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
  end
  
  validates_presence_of     :name, :shortname
  validates_length_of        :name,    :within => 0..200
  validates_length_of        :shortname,    :within => 0..20
  validates_length_of        :summary,    :within => 0..700, :allow_nil=>true
  validates_length_of        :style,    :within => 0..20, :allow_nil=>true
end
