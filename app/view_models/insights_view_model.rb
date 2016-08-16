class InsightsViewModel
  def active_count
    AuctionQuery.new.active_auction_count
  end

  def upcoming_count
    AuctionQuery.new.upcoming_auction_count
  end

  def hero_metrics
    InsightMetric.all
  end

  def sorted_skills_count
    skills_count.sort_by { |skill_count| -skill_count.evaluated_auction_count }
  end

  private

  def skills_count
    Skill.all.map { |skill| SkillPresenter.new(skill) }
  end
end
