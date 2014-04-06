class Word < ActiveRecord::Base
  has_attached_file :image
  belongs_to :book
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
