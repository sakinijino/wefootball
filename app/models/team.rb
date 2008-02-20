class Team < ActiveRecord::Base
  DEFAULT_IMAGE = "/images/default_team.jpg"
          
  has_one :team_image
  
  has_many :trainings,
            :dependent => :destroy
  
  has_many :user_teams,
            :dependent => :destroy
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
  end
  
  has_many :team_join_requests,
            :dependent => :destroy
  
  validates_presence_of     :name, :shortname
  validates_length_of        :name,    :maximum => 200
  validates_length_of        :shortname,    :maximum => 20
  validates_length_of        :summary,    :maximum => 700
  validates_length_of        :style,    :maximum => 20
  
  GENERIC_ANALYSIS_REGEX = /([a-zA-Z]|[\xc0-\xdf][\x80-\xbf])+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/
  GENERIC_ANALYZER = Ferret::Analysis::RegExpAnalyzer.new(GENERIC_ANALYSIS_REGEX, true)  
#  GENERIC_ANALYZER = MultilingualFerretTools::Analyzer.new
#  GENERIC_ANALYZER = Ferret::Analysis::StandardAnalyzer.new
  acts_as_ferret({:fields => [
        :name,
        :shortname
      ]},
    { :analyzer => GENERIC_ANALYZER })
  
  def image
    return self.team_image.public_filename if self.team_image != nil
    DEFAULT_IMAGE
  end
end
