class RedentionsController < ApplicationController
  before_action :set_redention, only: [:create, :show, :edit, :update, :destroy]
  PAGE_SIZE = 10

  # GET /redentions
  # GET /redentions.json
  def index
    # clear no saved redentions:
    unsaved_redentions = Redention.where(state: "draft", user: current_user)
    unsaved_redentions.each do |redention|
      redention.destroy
    end

    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user)
    @redentions, @number_of_pages = search.redentions
  end

  # GET /redentions/1
  # GET /redentions/1.json
  def show
  end

  # GET /redentions/new
  def new
    last_redention = Redention.where(state: "confirmed", user: current_user).maximum('number')
    number =  (last_redention != nil) ? last_redention + 1 : 1
    @redention = Redention.create( fecha: Date::current, number: number, state: "draft", user_id: current_user)
    @redention.redention_details.build
    params[:redention_id] = @redention.id.to_s
  end

  # GET /redentions/1/edit
  def edit
  end

  # POST /redentions
  # POST /redentions.json
  def create
  end

  # PATCH/PUT /redentions/1
  # PATCH/PUT /redentions/1.json
  def update
    @redention.confirmed!
    respond_to do |format|
      if @redention.update(redention_params)
        format.html { redirect_to redentions_url, notice: 'Venta actualizada.' }
        format.json { render :show, status: :ok, location: @redention }
      else
        format.html { render :edit }
        format.json { render json: @redention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redentions/1
  # DELETE /redentions/1.json
  def destroy
    @redention.destroy
    respond_to do |format|
      format.html { redirect_to redentions_url, notice: 'Venta eliminada.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redention
      @redention = Redention.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redention_params
      params.require(:redention).permit(:number, :date, redention_details_attributes: [:id, :redention_id, :item_id, :number, :qty, :price, :_destroy] )
    end
end