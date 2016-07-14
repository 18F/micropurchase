class Admin::NewSkillViewModel < Admin::BaseViewModel
  attr_reader :params

  def initialize(params = { })
    @params = params
  end

  def new_record
    Skill.new(params)
  end
end
