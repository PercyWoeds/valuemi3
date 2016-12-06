module ServicebuysHelper

	  def checkServices()
    if(params[:company_id])
      service = Servicebuy.where(company_id: params[:company_id])
    
      if(not service)
        flash[:error] = "Por favor crear un  servicio primero."
        redirect_to "/servicebuys/new/#{params[:company_id]}"
      end
    end
  end
end
