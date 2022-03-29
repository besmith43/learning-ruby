class WorkExperiencesController < ApplicationController
  before_action :set_work_experience, only: [:show, :edit, :update, :destroy]

  # GET /work_experiences
  # GET /work_experiences.json
  def index
    @work_experiences = WorkExperience.all
  end

  # GET /work_experiences/1
  # GET /work_experiences/1.json
  def show
  end

  # GET /work_experiences/new
  def new
    @work_experience = WorkExperience.new
  end

  # GET /work_experiences/1/edit
  def edit
  end

  # POST /work_experiences
  # POST /work_experiences.json
  def create
    @work_experience = WorkExperience.new(work_experience_params)

    respond_to do |format|
      if @work_experience.save
        format.html { redirect_to @work_experience, notice: 'Work experience was successfully created.' }
        format.json { render :show, status: :created, location: @work_experience }
      else
        format.html { render :new }
        format.json { render json: @work_experience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_experiences/1
  # PATCH/PUT /work_experiences/1.json
  def update
    respond_to do |format|
      if @work_experience.update(work_experience_params)
        format.html { redirect_to @work_experience, notice: 'Work experience was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_experience }
      else
        format.html { render :edit }
        format.json { render json: @work_experience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_experiences/1
  # DELETE /work_experiences/1.json
  def destroy
    @work_experience.destroy
    respond_to do |format|
      format.html { redirect_to work_experiences_url, notice: 'Work experience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_experience
      @work_experience = WorkExperience.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_experience_params
      params.require(:work_experience).permit(:owner, :start_date, :end_date, :name, :description)
    end
end
