class SkillPresenter
  attr_reader :skill

  def initialize(skill)
    @skill = skill
  end

  def name
    skill.name
  end

  def evaluated_auction_count
    SkillQuery.new(skill).evaluated_auction_count
  end

  def accepted_auction_count
    SkillQuery.new(skill).accepted_auction_count
  end
end
