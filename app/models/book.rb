require 'tesseract'
require 'RMagick'

class Book
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Magick


  field :name
  field :reference
  field :lang, default: 'eng'
  field :whole_text
  field :generating, type: Boolean
  field :generated, type: Boolean

  has_mongoid_attached_file :attachment, :styles => { full: '2048x2048>',:medium => "300x300>", :thumb => "100x100>" }


  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  embeds_many :pages
  
  def playable?
    generated
  end

  def destroy_words
    words.map(&:destroy)
  end

  def words
    a = []
    pages.each do |p|
      a = a + p.words
    end
    a
  end


  def generate_words

    self.generating = true
    save

    e = Tesseract::Engine.new {|e|
      e.language  = lang.to_sym
      e.blacklist = '|'
    }

      logger.error "Initiated tesseract ----------------------"

    logger.error "Starting Generating ----------------------"

    pages.each do |page|

      image_path = page.attachment.path

      boxes = []
      ocr_words = []
      e.each_word_for(image_path) do |word|
       boxes << word.bounding_box
      end

      logger.error "Done bounding ----------------------"

      image = Image.read(image_path).first

      #self.whole_text = e.text_for(image_path) if whole_text.blank?

      #self.save

      logger.error "Starting to save ----------------------"

      boxes.each_with_index do |box, i|
        logger.error "Saving image #{i}"
        b = image.crop(box.x, box.y, box.width, box.height);
        f = b.write("#{Rails.root}/tmp/word#{i}.png")
        word = page.words.build
        word.ocr_text = e.text_for(f.filename) if lang == 'eng'
        word.image = open f.filename
        word.image_file_name = "book#{id}word#{i}.png"
        word.save
      end
      page.generated = true
      page.save
    end

    self.generating = false
    self.generated = true
    save
  end

  def can_add? page
    similar_pages = self.pages.find_by filename: page
    similar_pages.nil?
  end
end
