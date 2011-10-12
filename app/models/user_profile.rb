class UserProfile < ActiveRecord::Base
  image_accessor :picture do
    storage_path :generate_picture_path
  end

  belongs_to :user

  protected

  def generate_picture_path
    hash = Digest::SHA1.file(picture.path).hexdigest
    "profile_pictures/#{hash[0..2]}/#{hash[3..5]}/#{hash}"
  end
end
