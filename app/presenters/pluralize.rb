class Pluralize
  include ActionView::Helpers::TextHelper

  attr_reader :number, :word

  def initialize(number:, word:)
    @number = number
    @word = word
  end

  def to_s
    pluralize(number, word)
  end
end
