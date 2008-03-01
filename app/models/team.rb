class Team < ActiveRecord::Base
  DEFAULT_IMAGE = "/images/default_team.jpg"
          
  has_one :team_image,
            :dependent => :destroy
  
  has_many :trainings,
            :dependent => :destroy do
    def recent(limit=nil, timeline=Time.now)
      find :all, :conditions => ['start_time > ?', timeline], 
        :order=>'start_time', 
        :limit=>limit
    end
  end
  
  has_many :user_teams,
            :dependent => :destroy
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
    def limit(num=nil)
      find :all, :limit=>num
    end
  end
  
  has_many :team_join_requests,
            :dependent => :destroy
          
  has_many :posts, :dependent => :destroy, :order => "updated_at desc" do
    def public
      find :all, :conditions => ['is_private = ?', false]
    end
  end
  
  validates_presence_of     :name, :shortname
  validates_length_of        :name,    :maximum => 200
  validates_length_of        :shortname,    :maximum => 20
  validates_length_of        :summary,    :maximum => 700, :allow_nil=>true
  validates_length_of        :style,    :maximum => 20
  validates_associated :team_image, :allow_nil => true
  
  attr_protected :uploaded_data
  
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
  
  def positions
    UserTeam.team_positions(self)
  end
end
