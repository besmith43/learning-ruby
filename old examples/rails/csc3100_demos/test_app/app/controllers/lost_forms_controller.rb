class LostFormsController < ApplicationController
  before_action :set_lost_form, only: [:show, :edit, :update, :destroy]

  # GET /lost_forms
  # GET /lost_forms.json
  def index
    @lost_forms = LostForm.all
  end

  # GET /lost_forms/1
  # GET /lost_forms/1.json
  def show
  end

  # GET /lost_forms/new
  def new
    @lost_form = LostForm.new
  end

  # GET /lost_forms/1/edit
  def edit
  end

  # POST /lost_forms
  # POST /lost_forms.json
  def create
    @lost_form = LostForm.new(lost_form_params)

    respond_to do |format|
      if @lost_form.save
        format.html { redirect_to @lost_form, notice: 'Lost form was successfully created.' }
        format.json { render :show, status: :created, location: @lost_form }
      else
        format.html { render :new }
        format.json { render json: @lost_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lost_forms/1
  # PATCH/PUT /lost_forms/1.json
  def update
    respond_to do |format|
      if @lost_form.update(lost_form_params)
        format.html { redirect_to @lost_form, notice: 'Lost form was successfully updated.' }
        format.json { render :show, status: :ok, location: @lost_form }
      else
        format.html { render :edit }
        format.json { render json: @lost_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lost_forms/1
  # DELETE /lost_forms/1.json
  def destroy
    @lost_form.destroy
    respond_to do |format|
      format.html { redirect_to lost_forms_url, notice: 'Lost form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost_form
      @lost_form = LostForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lost_form_params
      params.require(:lost_form).permit(:current_date, :lost_date, :phone, :owner_name, :pet_name, :collar, :tags, :color, :species, :breed, :gender, :size, :spayed_neutered, :found, :comments)
    end
end
