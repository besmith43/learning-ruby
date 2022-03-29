class SkillsAndInterestsController < ApplicationController
  before_action :set_skills_and_interest, only: [:show, :edit, :update, :destroy]

  # GET /skills_and_interests
  # GET /skills_and_interests.json
  def index
    @skills_and_interests = SkillsAndInterest.all
  end

  # GET /skills_and_interests/1
  # GET /skills_and_interests/1.json
  def show
  end

  # GET /skills_and_interests/new
  def new
    @skills_and_interest = SkillsAndInterest.new
  end

  # GET /skills_and_interests/1/edit
  def edit
  end

  # POST /skills_and_interests
  # POST /skills_and_interests.json
  def create
    @skills_and_interest = SkillsAndInterest.new(skills_and_interest_params)

    respond_to do |format|
      if @skills_and_interest.save
        format.html { redirect_to @skills_and_interest, notice: 'Skills and interest was successfully created.' }
        format.json { render :show, status: :created, location: @skills_and_interest }
      else
        format.html { render :new }
        format.json { render json: @skills_and_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skills_and_interests/1
  # PATCH/PUT /skills_and_interests/1.json
  def update
    respond_to do |format|
      if @skills_and_interest.update(skills_and_interest_params)
        format.html { redirect_to @skills_and_interest, notice: 'Skills and interest was successfully updated.' }
        format.json { render :show, status: :ok, location: @skills_and_interest }
      else
        format.html { render :edit }
        format.json { render json: @skills_and_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills_and_interests/1
  # DELETE /skills_and_interests/1.json
  def destroy
    @skills_and_interest.destroy
    respond_to do |format|
      format.html { redirect_to skills_and_interests_url, notice: 'Skills and interest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skills_and_interest
      @skills_and_interest = SkillsAndInterest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skills_and_interest_params
      params.require(:skills_and_interest).permit(:owner, :skill_name, :skill_description)
    end
end
