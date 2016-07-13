class Admin::EditSkillViewModel < Admin::BaseViewModel
  attr_reader :skill

  def initialize(skill)
    @skill = skill
  end

  def record
    skill
  end
end
