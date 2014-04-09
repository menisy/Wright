require 'amatch'

class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Amatch

  field :text
  field :accuracy, type: Integer
  field :ocr_text
  field :guesses, type: Array
  field :validated, type: Boolean
  field :filename


  has_mongoid_attached_file :image
  belongs_to :page
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def add_guess word
    m = Levenshtein.new(word)
    score = word.length
    guesses.each do |guess|
      st = guess[0]
      dist = m.match(st)
      if dist == 0
        guess[1] = guess[1] + word.length * 2;
        return word.length * 2
      else
        guess[1] -= dist
        score -= dist
      end
    end
    guesses << [word, score]
    score
  end
end
