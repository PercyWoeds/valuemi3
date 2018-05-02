require "peru_sunat_ruc/version"
require "peru_sunat_ruc/connector"
require "peru_sunat_ruc/company"

module PeruSunatRuc
  
  def self.name_from(ruc_number)
    self.info_from(ruc_number).name
  end

  def self.address_from(ruc_number)
    self.info_from(ruc_number).address 
  end

  def self.taxpayer_type_from(ruc_number)
  	self.info_from(ruc_number).taxpayer_type
  end

  def self.taxpayer_condition_from(ruc_number)
  	  self.info_from(ruc_number).taxpayer_condition  	
  end

  def self.taxpayer_status_from(ruc_number)
  	  self.info_from(ruc_number).taxpayer_status
  end
  
  def self.inscription_date_from(ruc_number)
  	  self.info_from(ruc_number).inscription_date
  end
  
  def self.voucher_system_from(ruc_number)
  	  self.info_from(ruc_number).voucher_system
  end
  
  def self.accounting_system_from(ruc_number)
  	  self.info_from(ruc_number).accounting_system
  end

  def self.affiliate_ple_since_from(ruc_number)
  	  self.info_from(ruc_number).affiliate_ple_since
  end
  def self.electronic_emisor_from(ruc_number)
  	  self.info_from(ruc_number).electronic_emisor
  end
  
  
  def self.info_from(ruc_number)
  		Connector.get_info ruc_number  		 
  end
  		

     # electronic_emisor: page.at('/html/body/table[1]/tr[13]/td[2]').text

 


end


