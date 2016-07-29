class Admin::SkillsIndexViewModel < Admin::BaseViewModel
  def skills
    Skill.all.order(:name)
  end

  def new_button_partial
    'admin/skills/new_skill_button'
  end

  def skills_nav_class
    'usa-current'
  end
end
