class UserImage < ActiveRecord::Base
  WIDTH = 76
  HEIGHT = 76  
  SMALL_WIDTH = 48
  SMALL_HEIGHT = 48
  TINY_WIDTH = 32
  TINY_HEIGHT = 32
  
  belongs_to :user  
  has_attachment  :storage => :file_system, 
                  :content_type => :image, 
                  :resize_to => '76x76!',
                  :thumbnails => { :small => "48x48!", :tiny => "32x32!"},
                  :path_prefix => 'public/images/users',
                  :max_size => 2.megabytes,
                  :processor => :MiniMagick # attachment_fu looks in this order: ImageScience, Rmagick, MiniMagick

  validates_as_attachment # ok two lines if you want to do validation, and why wouldn't you?
  
  def before_save
    if (self.user != nil)
      self.user.image_path = self.public_filename
      self.user.save!
    end
  end
  
  def uploaded_data=(file_data)
    return nil if file_data.nil? || file_data.size == 0
    self.content_type = file_data.content_type
    ext = nil
    file_data.original_filename.gsub(/\.\w+$/) do |s|
      ext = s; ''
    end
    self.filename = "%08d#{ext}" % self.user_id if respond_to?(:filename)
    if file_data.is_a?(StringIO)
      file_data.rewind
      self.temp_data = file_data.read
    else
      self.temp_data = file_data.read #windows fix
    end
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    fn = thumbnail_name_for(thumbnail)
    path = fn.slice(0, 7).scan(/../)
    path << fn.slice(6, fn.length-6)
    File.join(RAILS_ROOT, file_system_path, *path)
  end
end
