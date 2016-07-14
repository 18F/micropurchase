class SkillQuery
  attr_reader :skill

  def initialize(skill)
    @skill = skill
  end

  def evaluated_auction_count
    Auction.evaluated.includes(:skills).where(skills: { id: skill.id }).count
  end

  def accepted_auction_count
    Auction.accepted.includes(:skills).where(skills: { id: skill.id }).count
  end
end
