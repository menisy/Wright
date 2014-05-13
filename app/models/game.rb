class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :words

  field :guesses, type: Array
  field :score
  field :time
end
