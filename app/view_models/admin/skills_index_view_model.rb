class Admin::SkillsIndexViewModel < Admin::BaseViewModel
  def skills
    Skill.all.order(:name)
  end

  def skills_nav_class
    'usa-current'
  end
end
