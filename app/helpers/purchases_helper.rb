module PurchasesHelper

  def checkSuppliers()
    if(params[:company_id])
      supplier  = Supplier.where(:company_id => params[:company_id])
    
      if(not supplier )
        flash[:error] = "Por favor crear un nuevo  proveedor primero."
        redirect_to "/suppliers/new/#{params[:company_id]}"
      end
    end
  end



  

end
