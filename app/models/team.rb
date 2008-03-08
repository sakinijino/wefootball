class Team < ActiveRecord::Base
  include ModelHelper
#  FORMATION_POSTIONS = ['GK', 'LB', 'LCB', 'CB', 'RCB', 'RB',
#    'LWB', 'LDM', 'DM', 'RDM', 'RWB',
#    'LM', 'LCM', 'CM', 'RCM', 'RM',
#    'ALM', 'LAM', 'AM', 'RAM', 'ARM',
#    'LWF', 'LCF', 'CF', 'RCF', 'RWF']
  FORMATION_POSITIONS =  (0...26).to_a
  DEFAULT_IMAGE = "/images/default_team.jpg"
          
  has_one :team_image,
            :dependent => :destroy
  
  has_many :trainings, :dependent => :destroy, :extend => ActivityCalendar
  
  has_many :user_teams,
            :dependent => :destroy
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
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
  validates_length_of        :name,    :maximum => 50
  validates_length_of        :shortname,    :maximum => 15
  validates_length_of        :summary,    :maximum => 3000, :allow_nil=>true
  validates_length_of        :style,    :maximum => 50
  
  attr_protected :uploaded_data
  
  def before_validation
    attribute_slice(:name, 50)
    attribute_slice(:shortname, 15)
    attribute_slice(:summary, 3000)
    attribute_slice(:style, 50)
  end
  
#  GENERIC_ANALYSIS_REGEX = /([a-zA-Z]|[\xc0-\xdf][\x80-\xbf])+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/
#  GENERIC_ANALYZER = Ferret::Analysis::RegExpAnalyzer.new(GENERIC_ANALYSIS_REGEX, true)  
##  GENERIC_ANALYZER = MultilingualFerretTools::Analyzer.new
##  GENERIC_ANALYZER = Ferret::Analysis::StandardAnalyzer.new
#  acts_as_ferret({:fields => [
#        :name,
#        :shortname
#      ]},
#    { :analyzer => GENERIC_ANALYZER })

  def self.find_by_contents(q)
    Team.find :all, :conditions => ["name like ? or shortname like ?", q, q]
  end
  
  def image(thumbnail = nil)
    return self.team_image.public_filename(thumbnail) if self.team_image != nil
    DEFAULT_IMAGE
  end
  
  def formation
    UserTeam.team_formation(self)
  end
end
