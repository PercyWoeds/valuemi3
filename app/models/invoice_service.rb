class InvoiceService < ActiveRecord::Base
  	before_save :set_preciocigv
	validates_presence_of :factura_id, :service_id, :price, :quantity, :discount, :total
  
  belongs_to :factura
  belongs_to :service


  private 

  def set_preciocigv
    self.preciocigv = price*1.18

  end 


end
