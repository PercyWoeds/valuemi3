class StoresController < ApplicationController
  before_filter :authenticate_user!

  def index  	
    
  	#@company = Company.find(params[:company_id])
    #@locations = @company.get_locations()
    #@divisions = @company.get_divisions()    

    if params[:search]
      @products = Product.search(params[:search]).order("created_at DESC").paginate(:page => params[:page])
    else
      @products = Product.order(:name).paginate(:page => params[:page])
    end   
	  @cart = current_cart

  end 

 

  def search 
     @company = Company.find(params[:company_id])     
     @pagetitle = "#{@company.name} - Products"
      if(@company.can_view(current_user))
        if(params[:restock])     
            if params[:search].blank?
                @products= Product.order("name  ASC").page(params[:page]).per_page(15)                        
            else            
                @products= Product.where(["code LIKE ?","%" +params[:search]+"%" ]).order("name ASC").page(params[:page]).per_page(15)                        
            end        
         end
      end
    
  end
  def show
  end
  

end
