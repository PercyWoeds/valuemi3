class DeliveryminesController < ApplicationController

  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path ="guia"
    @pagetitle = "deliverys"
  end

  # GET /deliverys/1
  # GET /deliverys/1.xml
  def show
    @delivery  = Deliverymine.find(params[:id])
    @customer = @delivery.customer    
    
  end

  # GET /deliverys/new
  # GET /deliverys/new.xml
  
  def new
    
  end

  # GET /deliverys/1/edit
  def edit
    
  end

  # POST /deliverys
  # POST /deliverys.xml
  def create
    
  end
  

  # PUT /deliverys/1
  # PUT /deliverys/1.xml
  def update
    
  end

  # DELETE /deliverys/1,a
  # DELETE /deliverys/1.xml
  def destroy
    @delivery = Deliverymine.find(params[:id])
    company_id = @delivery[:company_id]
    @delivery.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/deliveries/" + company_id.to_s) }
    end
  end




end
