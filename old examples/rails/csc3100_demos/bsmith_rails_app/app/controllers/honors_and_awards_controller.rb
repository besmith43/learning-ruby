class HonorsAndAwardsController < ApplicationController
  before_action :set_honors_and_award, only: [:show, :edit, :update, :destroy]

  # GET /honors_and_awards
  # GET /honors_and_awards.json
  def index
    @honors_and_awards = HonorsAndAward.all
  end

  # GET /honors_and_awards/1
  # GET /honors_and_awards/1.json
  def show
  end

  # GET /honors_and_awards/new
  def new
    @honors_and_award = HonorsAndAward.new
  end

  # GET /honors_and_awards/1/edit
  def edit
  end

  # POST /honors_and_awards
  # POST /honors_and_awards.json
  def create
    @honors_and_award = HonorsAndAward.new(honors_and_award_params)

    respond_to do |format|
      if @honors_and_award.save
        format.html { redirect_to @honors_and_award, notice: 'Honors and award was successfully created.' }
        format.json { render :show, status: :created, location: @honors_and_award }
      else
        format.html { render :new }
        format.json { render json: @honors_and_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /honors_and_awards/1
  # PATCH/PUT /honors_and_awards/1.json
  def update
    respond_to do |format|
      if @honors_and_award.update(honors_and_award_params)
        format.html { redirect_to @honors_and_award, notice: 'Honors and award was successfully updated.' }
        format.json { render :show, status: :ok, location: @honors_and_award }
      else
        format.html { render :edit }
        format.json { render json: @honors_and_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /honors_and_awards/1
  # DELETE /honors_and_awards/1.json
  def destroy
    @honors_and_award.destroy
    respond_to do |format|
      format.html { redirect_to honors_and_awards_url, notice: 'Honors and award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_honors_and_award
      @honors_and_award = HonorsAndAward.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def honors_and_award_params
      params.require(:honors_and_award).permit(:owner, :honor_date, :honor_name, :honor_description)
    end
end
