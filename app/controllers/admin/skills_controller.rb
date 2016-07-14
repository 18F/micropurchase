class Admin::SkillsController < Admin::BaseController
  def index
    @view_model = Admin::SkillsIndexViewModel.new
  end

  def new
    @view_model = Admin::NewSkillViewModel.new
  end

  def create
    skill = Skill.new(skill_params)

    if skill.save
      redirect_to admin_skills_path
    else
      flash.now[:error] = skill.errors.full_messages.to_sentence
      @view_model = Admin::NewSkillViewModel.new(skill_params)
      render :new
    end
  end

  def edit
    @view_model = Admin::EditSkillViewModel.new(skill)
  end

  def update
    if skill.update(skill_params)
      redirect_to admin_skills_path
    else
      flash.now[:error] = skill.errors.full_messages.to_sentence
      @view_model = Admin::EditSkillViewModel.new(skill)
      render :edit
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end

  def skill
    @_skill ||= Skill.find(params[:id])
  end
end
