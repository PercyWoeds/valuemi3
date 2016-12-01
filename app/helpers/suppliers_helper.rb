module SuppliersHelper
	  def checkSupplier()
    if(params[:company_id])
      supplier = Supplier.find(:first, :conditions => {:company_id => params[:company_id]})
    
      if(not supplier)
        flash[:error] = "Please create a customer first."
        redirect_to "/suppliers/new/#{params[:company_id]}"
      end
    end
  end

end
