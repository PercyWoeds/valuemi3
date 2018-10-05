class NoteConceptsController < ApplicationController
  before_action :set_note_concept, only: [:show, :edit, :update, :destroy]

  # GET /note_concepts
  # GET /note_concepts.json
  def index
    @note_concepts = NoteConcept.all
  end

  # GET /note_concepts/1
  # GET /note_concepts/1.json
  def show
  end

  # GET /note_concepts/new
  def new
    @note_concept = NoteConcept.new
  end

  # GET /note_concepts/1/edit
  def edit
  end

  # POST /note_concepts
  # POST /note_concepts.json
  def create
    @note_concept = NoteConcept.new(note_concept_params)

    respond_to do |format|
      if @note_concept.save
        format.html { redirect_to @note_concept, notice: 'Note concept was successfully created.' }
        format.json { render :show, status: :created, location: @note_concept }
      else
        format.html { render :new }
        format.json { render json: @note_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /note_concepts/1
  # PATCH/PUT /note_concepts/1.json
  def update
    respond_to do |format|
      if @note_concept.update(note_concept_params)
        format.html { redirect_to @note_concept, notice: 'Note concept was successfully updated.' }
        format.json { render :show, status: :ok, location: @note_concept }
      else
        format.html { render :edit }
        format.json { render json: @note_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /note_concepts/1
  # DELETE /note_concepts/1.json
  def destroy
    @note_concept.destroy
    respond_to do |format|
      format.html { redirect_to note_concepts_url, notice: 'Note concept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note_concept
      @note_concept = NoteConcept.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_concept_params
      params.require(:note_concept).permit(:code, :descrip, :td,:document_id )
    end
end
