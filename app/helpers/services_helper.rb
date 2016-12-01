module ServicesHelper

  def checkServices()
    if(params[:company_id])
      service = Service.where(company_id: params[:company_id])
    
      if(not service)
        flash[:error] = "Por favor crear un  servicio primero."
        redirect_to "/services/new/#{params[:company_id]}"
      end
    end
  end
end
