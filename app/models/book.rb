require 'tesseract'
require 'RMagick'

class Book < ActiveRecord::Base
  include Magick
  has_attached_file :attachment
  has_many :words
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  def playable?
    words != []
  end

  def destroy_words
    words.map(&:destroy)
  end


  def generate_words

    logger.error "Starting Generating ----------------------"

    image_path = attachment.path

    e = Tesseract::Engine.new {|e|
      e.language  = lang.to_sym
      e.blacklist = '|'
    }

    logger.error "Initiated tesseract ----------------------"

    boxes = []
    ocr_words = []
    e.each_word_for(image_path) do |word|
     boxes << word.bounding_box
    end

    logger.error "Done bounding ----------------------"

    image = Image.read(image_path).first

    self.whole_text = e.text_for(image_path) if whole_text.blank?

    self.save

    logger.error "Starting to save ----------------------"

    boxes.each_with_index do |box, i|
      b = image.crop(box.x, box.y, box.width, box.height);
      f = b.write("#{Rails.root}/public/word#{i}.png")
      word = words.build
      word.ocr_text = e.text_for(f.filename) if lang == 'eng'
      word.image = open f.filename
      word.image_file_name = "book#{id}word#{i}.png"
      word.save
    end
  end
end
