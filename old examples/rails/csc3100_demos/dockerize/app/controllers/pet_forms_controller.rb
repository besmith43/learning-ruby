class PetFormsController < ApplicationController
  before_action :set_pet_form, only: [:show, :edit, :update, :destroy]

  # GET /pet_forms
  # GET /pet_forms.json
  def index
    @pet_forms = PetForm.all
  end

  # GET /pet_forms/1
  # GET /pet_forms/1.json
  def show
  end

  # GET /pet_forms/new
  def new
    @pet_form = PetForm.new
  end

  # GET /pet_forms/1/edit
  def edit
  end

  # POST /pet_forms
  # POST /pet_forms.json
  def create
    @pet_form = PetForm.new(pet_form_params)

    respond_to do |format|
      if @pet_form.save
        format.html { redirect_to @pet_form, notice: 'Pet form was successfully created.' }
        format.json { render :show, status: :created, location: @pet_form }
      else
        format.html { render :new }
        format.json { render json: @pet_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pet_forms/1
  # PATCH/PUT /pet_forms/1.json
  def update
    respond_to do |format|
      if @pet_form.update(pet_form_params)
        format.html { redirect_to @pet_form, notice: 'Pet form was successfully updated.' }
        format.json { render :show, status: :ok, location: @pet_form }
      else
        format.html { render :edit }
        format.json { render json: @pet_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pet_forms/1
  # DELETE /pet_forms/1.json
  def destroy
    @pet_form.destroy
    respond_to do |format|
      format.html { redirect_to pet_forms_url, notice: 'Pet form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet_form
      @pet_form = PetForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pet_form_params
      params.require(:pet_form).permit(:date, :date_since, :phone, :owner_name, :pet_name, :color, :collar, :tags, :breed, :gender, :size, :spayed_neutered, :area, :comments, :lost_found, :pending)
    end
end
