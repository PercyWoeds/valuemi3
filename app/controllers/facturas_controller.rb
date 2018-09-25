include CustomersHelper
include ServicesHelper
require 'sunat_books'

class FacturasController < ApplicationController

    $: << Dir.pwd  + '/lib'
    before_action :authenticate_user!
    
    require "open-uri"
   
  def reportes
  
    @company=Company.find(1)          
    @fecha = params[:fecha1]    
    
    @parte_rpt = @company.get_parte_1(@fecha)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte_rpt.pdf.erb",locals: {:varillajes => @parte_rpt},
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        
             
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
  def reportes2 
  
    @company=Company.find(1)          
    @fecha = params[:fecha1]    
    
    @parte_rpt = @company.get_parte_1(@fecha)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte2_rpt.pdf.erb",locals: {:varillajes => @parte_rpt}
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
  def reportes3 
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @contado_rpt = @company.get_parte_2(@fecha1,@fecha2)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte3_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
        :orientation      => 'Landscape'
        end   
      when "To Excel" then render xlsx: 'parte3_rpt_xls'
      else render action: "index"
    end
  end
  
def reportes4
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    
    @contado_rpt = @company.get_parte_4(@fecha1,@fecha2)
    
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Parte4 ",template: "varillajes/parte4_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
         :orientation      => 'Landscape'
        end   
      when "To Excel" then render xlsx: 'parte4_rpt_xls'
      else render action: "index"
    end
  end
  
  
#Vale credito por clientes todos 
def reportes5
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:cod_cli]    
    
    
    @contado_rpt = @company.get_parte_3(@fecha1,@fecha2,@cliente)
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Vale5 ",template: "varillajes/parte5_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }

        end   
        when "To Excel" then render xlsx: 'parte4_rpt_xls'
      else render action: "index"
    end
  end

#tarjeta credito por clientes todos 
def reportes6
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:cod_cli]    
    @tarjetacheck = params[:tarjetacheck]    
    @tarjeta_id = params[:tarjeta_id]    
    
    if @tarjetacheck == "1"
        @contado_rpt = @company.get_parte_5(@fecha1,@fecha2)
    else
        @contado_rpt = @company.get_parte_5_b(@fecha1,@fecha2,@tarjeta_id)
    end 
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Vale5 ",template: "varillajes/parte6_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end

#tarjeta credito por clientes todos 
def reportes7
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente_select = params[:cbox1]    
    @customer = params[:customer_id]
    
      
    
    if @cliente_select == "1"
        @contado_rpt = @company.get_parte_6(@fecha1,@fecha2)
    else
      @contado_rpt = @company.get_parte_6_1(@fecha1,@fecha2,@customer)
    end 
    
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Vale5 ",template: "varillajes/parte7_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        
        end   
      when "To Excel" then render xlsx: 'parte7_rpt_xls'
      else render action: "index"
    end
  end
  
def reportes8
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
  
    @contado_rpt1 = @company.get_ventas_contometros_efectivo_sustento2(@fecha1,@fecha2)  
    @contado_rpt2 = @company.get_parte_2(@fecha1,@fecha2) #contadp
    @contado_rpt4 = @company.get_parte_4(@fecha1,@fecha2) #creditos
    @contado_rpt5 = @company.get_parte_5(@fecha1,@fecha2) #tarjeta 
    @contado_rpt6 = @company.get_parte_6(@fecha1,@fecha2) #pago adelantado
    
    @contado_adel0 = @company.get_parte_6b(@fecha1,@fecha2) # total saldo vales adelantados inicial
    
    @fecha0 = "2018-03-01"
    @contado_adel1 = @company.get_ventas_mayor_anterior(@fecha0,@fecha1,"4") # total saldo facturas adelantadas inicial
    
    @contado_rpt7 = @company.get_ventas_vale_directo(@fecha1,@fecha2) #ventas directa
    
    @total_combus = @company.get_ventas_contometros(@fecha1,@fecha2) #ventas market 
    
    @total_market = @company.get_ventas_market_total(@fecha1,@fecha2)  +@company.get_ventas_colaterales_efe(@fecha1,@fecha2,"2" )+@company.get_ventas_colaterales_tar(@fecha1,@fecha2,"2" )  +@company.get_ventas_colaterales_efe(@fecha1,@fecha2,"3" )+@company.get_ventas_colaterales_tar(@fecha1,@fecha2,"3" )
    
    @total_directa = @company.get_ventas_mayor(@fecha1,@fecha2,"3") #ventas market 
    
    @total_adelantada_bruta = @company.get_ventas_adelantado_suma(@fecha1,@fecha2) 
    
    @total_adelantada = @contado_adel1 -@contado_adel0 + @total_adelantada_bruta - @company.get_ventas_contometros_adelantado(@fecha1,@fecha2)
    
    @total_venta = @company.get_ventas_all_series(@fecha1,@fecha2)
    
    @total_boletas= @company.get_ventas_contometros_efectivo(@fecha1,@fecha2)  + @total_venta   #ventas boletas reg ventas playa
    
    
    @total_contado_pendiente = @company.get_contado_pendiente(@fecha1,@fecha2)
    @total_credito_pendiente_detalle = @company.get_credito_pendiente_detalle(@fecha1,@fecha2)
    
    @total_factura_out_fecha = @company.get_credito_out_fecha(@fecha1,@fecha2)
    @total_factura_out_fecha2 = @company.get_credito_out_fecha2(@fecha1,@fecha2,"1")
    
    @total_credito_pendiente = @company.get_credito_pendiente(@fecha1,@fecha2)
    
    @total_factura_out_fecha_detalle =@company.get_credito_out_fecha_detalle(@fecha1,@fecha2)
    
    @total_factura_out_fecha_detalle2 =@company.get_credito_out_fecha_detalle2(@fecha1,@fecha2,"1")
    
    @total_venta_combustible_fecha = @company.get_ventas_combustibles_fecha(@fecha1,@fecha2)
 
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte8_rpt.pdf.erb",locals: {:varillajes => @parte_rpt},
         :orientation    => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               },
               
               footer: {
                              spacing: 30,
                 line: true
               }
               
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end


def reportes9 
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:cod_cli]    
       
    
    @contado_rpt = @company.get_ventas_combustibles(@fecha1,@fecha2)
    @producto = @company.get_productos_comb 
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Vale5 ",template: "varillajes/parte9_rpt.pdf.erb",locals: {:varillajes => @contado_rpt},
         :orientation      => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
        
        end   
      when "To Excel" then render xlsx: 'parte9_rpt_xls'
      else render action: "index"
    end
  end
  

def rpt_pago_adelantado
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
    
    @cbox1 = params[:cbox1]    
    @cliente  = params[:customer_id]    
    
    puts "xbox1 "
    puts @cbox1
    
     if @cbox1 == "1"
        @contado_rpt_adelantado = @company.get_pago_adelantado(@fecha1,@fecha2)
     else
        @contado_rpt_adelantado = @company.get_pago_adelantado_cliente(@fecha1,@fecha2,@cliente)
     end 
        
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte13_rpt.pdf.erb",locals: {:varillajes => @contado_rpt_adelantado},
         :orientation    => 'Landscape',
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               },
               
               footer: {
                              spacing: 30,
                 line: true
               }
               
        end   
      when "To Excel" then render xlsx: 'parte11_rpt_xls'
      else render action: "index"
    end
  end

def reportes12
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
  
    @parte_rpt = @company.get_parte_10(@fecha1,@fecha2)  
    
    @total_factura_out_fecha_detalle2 =@company.get_credito_out_fecha_detalle2(@fecha1,@fecha2,"3")
  
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte12_rpt.pdf.erb",locals: {:varillajes => @parte_rpt},
                  :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               },
               
               footer: {
                              spacing: 30,
                 line: true
               }
               
        end   
      when "To Excel" then render xlsx: 'parte13_rpt_xls'
      else render action: "index"
    end
  end

def reportes13
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
  
    @contado_rpt1 = @company.get_ventas_contometros_descuento_detalle(@fecha1,@fecha2)  
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "varillajes/parte13_rpt.pdf.erb",locals: {:varillajes => @contado_rpt1},
         :orientation    => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               },
               
               footer: {
                              spacing: 30,
                 line: true
               }
               
        end   
      when "To Excel" then render xlsx: 'parte13_rpt_xls'
      else render action: "index"
    end
  end

def reportes14
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
  

    @company.actualizar_fecha2
    @company.actualizar_detraccion 

    @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  

    
    case params[:print]
    
      when "To PDF" then 
          begin 
          redirect_to :action => "rpt_ccobrar2_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :customer_id => params[:customer_id] 
          end 
      when "To Excel" then render xlsx: 'rpt_ccobrar2_xls'
      else render action: "index"
    end
  end



def rpt_factura_all
    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    
  

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2,@moneda)          
    
    @total1  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"subtotal")  
    @total2  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"tax")  
    @total3  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"total")  
    
    
    
    case params[:print]
      when "To PDF" then 
        begin 
        # lcCompany = "20555691263"
        # lcmonth ='03'
        # lcyear = '2018'
        # pdf = SunatBooks::Pdf::Sales.new(company, @facturas_rpt, lcmonth, lcyear)
        # pdf.render
        
          render  pdf: "Facturas ",template: "facturas/rventas_rpt.pdf.erb",locals: {:facturas => @facturas_rpt},
             :orientation      => 'Landscape', :page_size => "A3"
        
        end   
      when "To Excel" then render xlsx: 'rventas_rpt_xls'
      else render action: "index"
    end
  end
  
def rpt_factura_all3
    $lcFacturasall = '1'

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    
  

    @facturas_rpt = @company.get_facturas_day3(@fecha1,@fecha2,@moneda)          
    
    @total1  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"subtotal")  
    @total2  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"tax")  
    @total3  = @company.get_facturas_by_day_value2(@fecha1,@fecha2,@moneda,"total")  
    
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas_rpt3.pdf.erb",locals: {:facturas => @facturas_rpt},
        :orientation      => 'Landscape'
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
 
 end
  
def reportes03


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_combustibles(@fecha1,@fecha2)          
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas03_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
         :orientation      => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'exportxls'
      else render action: "index"
    end
  end
  
def reportes05


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_combustibles_producto(@fecha1,@fecha2)          
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas05_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
         :orientation      => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reportes05'
        
      else render action: "index"
    end
  end
  
def reportes06


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_adelantado(@fecha1,@fecha2)          
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas06_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
           :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reportes05'
        
      else render action: "index"
    end
  end
def reportes07

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_directa(@fecha1,@fecha2)          
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas07_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
           :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reportes05'
        
      else render action: "index"
    end
  end

def reportes08


    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]
    

    @facturas_rpt = @company.get_ventas_adelantado(@fecha1,@fecha2)          
    @facturas_detalle = @company.get_parte_6(@fecha1,@fecha2)          
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas08_rpt.pdf.erb",
         locals: {:facturass => @facturas_rpt},
           :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
        end   
      when "To Excel" then render xlsx: 'reportes08'
        
      else render action: "index"
    end
  end

def reportes09

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_ventas_colaterales(@fecha1,@fecha2)          
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas09_rpt.pdf.erb",
         locals: {:facturas => @facturas_rpt},
         :orientation      => 'Landscape',
         
         :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reporte09xls'
      else render action: "index"
    end
  end


def reportes10

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    
    
    
    @cbox1 = params[:cbox1]    
    @cbox2 = params[:cbox2]    
    
    @cliente  = params[:customer_id]    
    
    
    
    
   if @cbox1 == "1"
    @facturas_rpt = @company.get_ventas_all(@fecha1,@fecha2)          
   else
    @facturas_rpt = @company.get_ventas_all2(@fecha1,@fecha2,@cliente)          
   end 
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas10_rpt.pdf.erb",
         :orientation      => 'Landscape',
         locals: {:facturas => @facturas_rpt},
            :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        end   
      when "To Excel" then render xlsx: 'reporte10xls'
      else render action: "index"
    end
  end
def reportes11

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    
    
    @cbox1 = params[:cbox1]    
    @cbox2 = params[:cbox2]    
    @cliente  = params[:customer_id]    
    
    
   if @cbox1 == "1"
    @facturas_rpt = @company.get_ventas_all(@fecha1,@fecha2)          
   else
    @facturas_rpt = @company.get_ventas_all2(@fecha1,@fecha2,@cliente)          
   end 
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Facturas ",template: "facturas/rventas10_rpt.pdf.erb",
         :orientation      => 'Landscape',
         locals: {:facturas => @facturas_rpt},
            :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
        end   
      when "To Excel" then render xlsx: 'reporte10xls'
      else render action: "index"
    end
  end



def reportes31 
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2] 
  
    @facturas = @company.get_venta_detallado(@fecha1,@fecha2)  
   
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ventas",template: "varillajes/ventas_detalle_rpt.pdf.erb",locals: {:varillajes => @facturas },
                  :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               },
               
               footer: {
                              spacing: 30,
                 line: true
               }
               
        end   
      when "To Excel" then render xlsx: 'ventas_detalle_rpt'
      else render action: "index"
    end
  end



  def discontinue
    
    @facturasselect = Factura.find(params[:products_ids])

    for item in @guiasselect
        begin
          a = item.id
          b = item.remite_id               
          new_invoice_guia = Deliverymine.new(:mine_id =>$minesid, :delivery_id =>item.id)          
          new_invoice_guia.save
           
        
        end              
    end
  end  
  def excel

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2)      

    respond_to do |format|
      format.html    
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end 
  end 

  def import
      Factura.import(params[:file])
       redirect_to root_url, notice: "Factura importadas."
  end 


    # Export invoice to PDF
  def pdf
    @invoice = Factura.find($lcIdFactura)
    @company = Company.find(1)
    
        Prawn::Document.generate "app/pdf_output/ticket2.pdf" , :margin => [10,15,12,5]  do |pdf|   
        
        pdf.font "Helvetica"
        pdf = build_header_tk(pdf)
        pdf = build_body_tk(pdf)
        
        $lcFileName =  "app/pdf_output/ticket2.pdf"              
        end 
        
    
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/ticket2.pdf", :type => 'application/pdf', :disposition => 'inline')

      
    
  end
  
  # Process an invoice
  def do_process
    @invoice = Factura.find(params[:id])
    @invoice[:processed] = "1"
    @invoice.process
    
    flash[:notice] = "The invoice order has been processed."
    redirect_to @invoice
  end
  
  # Do send invoice via email
  def do_email
    @invoice = Factura.find(params[:id])
    @email = params[:email]
    
    Notifier.invoice(@email, @invoice).deliver
    
    
    flash[:notice] = "The invoice has been sent successfully."
    redirect_to "/facturas/#{@invoice.id}"
  end
  
  # Send invoice via email
  def email
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
  end

  def do_anular
    @invoice = Factura.find(params[:id])
    @invoice[:processed] = "2"
    
    @invoice.anular 
    @invoice.delete_products()
    @invoice.delete_guias()
  
    flash[:notice] = "Documento a sido anulado."
    redirect_to @invoice 
  end
  
  
  # List items
  def list_items
    
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_f
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:currtotal] = total
        
        @products.push(product)
      end
      
      i += 1
   end
    
    render :layout => false
  end
  
  def list_items2
    
    @company = Company.find(params[:company_id])
    items = params[:items2]
    items = items.split(",")
    items_arr = []
    @guias = []
    i = 0

    for item in items
      if item != ""
        parts = item.split("|BRK|")

        puts parts

        id = parts[0]      
        product = Delivery.find(id.to_i)
        product[:i] = i

        @guias.push(product)


      end
      
      i += 1
    end

    render :layout => false
  end 

  def ac_facturas  

    @facturas = Factura.where(["company_id = ? AND (code LIKE ?)", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end
  
  
  # Autocomplete for products
  def ac_guias
    procesado = '1'
    @guias = Delivery.where(["company_id = ? AND (code LIKE ?)   ", params[:company_id], "%" + params[:q] + "%"])   
    render :layout => false
  end

  
  # Autocomplete for products
  def ac_services
    @products = Service.where(["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.where(company_id: params[:company_id])
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.where(["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(current_user)
    end
   
    render :layout => false
  end
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.where(["company_id = ? AND (ruc iLIKE ? OR name iLIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show invoices for a company
  def list_invoices
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Invoices"
    @filters_display = "block"
    
    @locations = Location.where(company_id: @company.id).order("name ASC")
    @divisions = Division.where(company_id: @company.id).order("name ASC")
    
    
    if(@company.can_view(current_user))
      
      
      if @current_user.level == "colateral"
        
         @invoices = Factura.all.order('fecha DESC','serie DESC','code DESC').paginate(:page => params[:page]).where(serie:"BB04")
         
        if params[:search]
          @invoices = Factura.search(params[:search]).order('fecha DESC','serie DESC','code DESC').paginate(:page => params[:page]).where(serie:"BB04")
        else
          @invoices = Factura.order('fecha DESC','serie DESC','code DESC').paginate(:page => params[:page]).where(serie:"BB04")
        end
        
        @turno = Turno.first 
        
        
      else 
        
         #@invoices = Factura.all.order('fecha DESC,code  DESC').paginate(:page => params[:page])
         
            @invoices  = Factura.joins(:customer).order('fecha DESC,code  DESC').paginate(:page => params[:page])
  
                      
            search = params[:search]
            
            unless params[:search].blank?
            
              @invoices = Factura.find_by_sql(['Select facturas.*, customers.name 
                      from facturas 
                      INNER JOIN customers ON facturas.customer_id = customers.id
                      where customers.name iLIKE ? or facturas.code ilike ?',"%#{search}%","%#{search}%" ] ).paginate(:page => params[:page])
            end
            
         
         
        # if params[:search]
        #   @invoices = Factura.search(params[:search]).order('fecha DESC ,code DESC').paginate(:page => params[:page])
        # else
        #   @invoices = Factura.order('fecha DESC ,code  DESC').paginate(:page => params[:page]) 
        # end
        
      end 
      
      else
      errPerms()
    end
  end
  
  # GET /invoices
  # GET /invoices.xml
  def index
    @companies = Company.where(user_id: current_user.id).order("name")
    @path = 'factura'
    @pagetitle = "Facturas"
    

    @invoicesunat = Invoicesunat.order(:numero)    

    @company= Company.find(1)

  end

  def export
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end
  def export3
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end
  def export4
    @company = Company.find(params[:company_id])
    @facturas  = Factura.all
  end

  def generar4
    
    @company = Company.find(params[:company_id])
     Csubdiario.delete_all
     Dsubdiario.delete_all


     fecha1 =params[:fecha1]
     fecha2 =params[:fecha2]

     @facturas = @company.get_facturas_day(fecha1,fecha2)

      $lcSubdiario='05'

      subdiario = Numera.find_by(:subdiario=>'12')

      lastcompro = subdiario.compro.to_i + 1
      $lastcompro1 = lastcompro.to_s.rjust(4, '0')

        item = fecha1.to_s 
        parts = item.split("-")        
        
        mm    = parts[1]        

      if subdiario
          nrocompro = mm << $lastcompro1
      end


     for f in @facturas
        
        $lcFecha =f.fecha.strftime("%Y-%m-%d")   
        

      newsubdia =Csubdiario.new(:csubdia=>$lcSubdiario,:ccompro=>$lastcompro1,:cfeccom=>$lcFecha, :ccodmon=>"MN",
        :csitua=>"F",:ctipcam=>"0.00",:cglosa=>f.code,:csubtotal=>f.subtotal,:ctax=>f.tax,:ctotal=>f.total,
        :ctipo=>"V",:cflag=>"N",:cdate=>$lcFecha ,:chora=>"",:cfeccam=>"",:cuser=>"SIST",
        :corig=>"",:cform=>"M",:cextor=>"",:ccodane=>f.customer.ruc ) 

        newsubdia.save

      lastcompro = lastcompro + 1
      $lastcompro1 = lastcompro.to_s.rjust(4, '0')      

      end 

      subdiario.compro = $lastcompro1
      subdiario.save

      @invoice = Csubdiario.all
      send_data @invoice.to_csv  , :filename => 'CC0317.csv'

    
  end

  def generar5

      option =  params[:archivo]
      puts option

      if option == "Ventas Cabecera"

        @invoice = Csubdiario.all
        send_data @invoice.to_csv  , :filename => 'CC0317.csv'

      else
        @invoice = Dsubdiario.all
        send_data @invoice.to_csv  , :filename => 'CD0317.csv'
      end 
  end 

  def export2
    Invoicesunat.delete_all
    @company = Company.find(params[:company_id])
    
    @facturas  = Factura.where(:tipo => 1)
     a = ""
     
     lcGuia=""
    for f in @facturas      
        @fec =(f.code)
        parts = @fec.split("-")
        lcSerie  = parts[0]
        lcNumero = parts[1]
        lcFecha  = f.fecha 
        
        lcTD = f.document.descripshort
        lcVventa = f.subtotal
        lcIGV = f.tax
        lcImporte = f.total 
        lcFormapago = f.payment.descrip
        lcRuc = f.customer.ruc         
        lcDes = f.description
        lcMoneda = f.moneda_id 
        lcDescrip=""
        lcPsigv = 0 
        lcPcigv = 0
        lcCantidad = 0
        lcGuia = ""
        lcComments = ""
        lcDes1 = ""
        
        for productItem in f.get_products_2

        lcPsigv= productItem.price
        lcPsigv1= lcPsigv*1.18
        lcPcigv = lcPsigv1.round(2)
        lcCantidad= productItem.quantity
        lcDescrip =  productItem.name 
        
        a = ""        
        lcDes1 = ""

        
        new_invoice_item= Invoicesunat.new(:cliente => lcRuc, :fecha => lcFecha,:td =>lcTD,
        :serie => lcSerie,:numero => lcNumero,:preciocigv => lcPcigv ,:preciosigv =>lcPsigv,:cantidad =>lcCantidad,
        :vventa => lcVventa,:igv => lcIGV,:importe => lcImporte,:ruc =>lcRuc,:guia => lcGuia,:formapago =>lcFormapago,
        :description => lcDescrip,:comments => lcComments,:descrip =>lcDescrip,:moneda =>lcMoneda,:codigo=> productItem.code)
        new_invoice_item.save
        
      end  
    end 
         
    
    @invoice = Invoicesunat.all
    send_data @invoice.to_csv  
    
  end
  
  def generar
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @pagetitle = "Generar archivo txt"
    
    @f =(params[:fecha1])

        parts = @f.split("-")
        yy = parts[0]
        mm = parts[1]
        dd = parts[2]

     @fechadoc=dd+"/"+mm+"/"+yy   
     @tipodocumento='01'
    
    files_to_clean =  Dir.glob("./app/txt_output/*.txt")
        files_to_clean.each do |file|
          File.delete(file)
        end 

    @facturas_all_txt = @company.get_facturas_year_month_day(@f)

    if @facturas_all_txt
      out_file = File.new("#{Dir.pwd}/app/txt_output/20424092941-RF-#{dd}#{mm}#{yy}-01.txt", "w")      
        for factura in @facturas_all_txt 
            parts = factura.code.split("-")
            @serie     =parts[0]
            @nrodocumento=parts[1]

            out_file.puts("7|#{@fechadoc}|#{@tipodocumento}|#{@serie}|#{@nrodocumento}||6|#{factura.customer.ruc}|#{factura.customer.name}|#{factura.subtotal}|0.00|0.00|0.00|#{factura.tax}|0.00|#{factura.total}||||\n")
                    
        end 
    out_file.close
    end 
    
    
  end

  def generar3
        
    @company = Company.find(params[:company_id])
    @users = @company.get_users()
    @users_cats = []
    
    @pagetitle = "Generar archivo"
    
    @f =(params[:fecha1])
    @f2 =(params[:fecha1])

        parts = @f.split("-")
        yy = parts[0]
        mm = parts[1]
        dd = parts[2]

     @fechadoc=dd+"/"+mm+"/"+yy   
     @tipodocumento='01'
    
    files_to_clean =  Dir.glob("./app/txt_output/*.txt")
        files_to_clean.each do |file|
          File.delete(file)
        end 

    @facturas_all_txt = @company.get_facturas_year_month_day2(@f,@f2)

    if @facturas_all_txt
        out_file = File.new("#{Dir.pwd}/app/txt_output/20424092941-RF-#{dd}#{mm}#{yy}-01.txt", "w")      
        for factura in @facturas_all_txt 
            parts = factura.code.split("-")
            @serie     =parts[0]
            @nrodocumento=parts[1]

            out_file.puts("7|#{@fechadoc}|#{@tipodocumento}|#{@serie}|#{@nrodocumento}||6|#{factura.customer.ruc}|#{factura.customer.name}|#{factura.subtotal}|0.00|0.00|0.00|#{factura.tax}|0.00|#{factura.total}||||\n")
                    
        end 
    out_file.close
    end 
    
    
  end
    

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Factura.find(params[:id])
    @company = Company.find(1)
    @customer = @invoice.customer
    @customers = @company.get_customers_all()
    
    @tipodocumento = @invoice.document 
    
    if @invoice.descuento == "1"
      @factura_details = @invoice.factura_details
    end 
    
    
    if current_user.level =="colateral"
    
        $lcruc = "20555691263" 
        
        $lcTipoDocumento = @invoice.document.descripshort
        parts1 = @invoice.code.split("-")
        $lcSerie  = parts1[0]
        $lcNumero = parts1[1]
        
        $lcIgv = @invoice.tax.round(2).to_s
        $lcTotal = @invoice.total.round(2).to_s 
        $lcFecha       = @invoice.fecha
        $lcFecha1      = $lcFecha.to_s
        $lg_fecha   = @invoice.fecha.to_date
        
              parts = $lcFecha1.split("-")
              $aa = parts[0]
              $mm = parts[1]        
              $dd = parts[2]       
    
        
          $lcFecha0 = $aa << "-" << $mm <<"-"<< $dd 
        
          if @invoice.document_id == 1 
            $lcTipoDocCli =  "1"
          else
            $lcTipoDocCli =  "6"
          end 
            $lcNroDocCli  = @invoice.customer.ruc 
      
            $lcCodigoBarra = $lcruc << "|" << $lcTipoDocumento << "|" << $lcSerie << "|" << $lcNumero << "|" <<$lcIgv<< "|" << $lcTotal << "|" << $lcFecha0 << "|" << $lcTipoDocCli << "|" << $lcNroDocCli
          
    else   
      
        @invoiceitems = FacturaDetail.select(:product_id,"SUM(quantity) as cantidad","SUM(total) as total").where(factura_id: @invoice.id).group(:product_id)
        
        $lg_fecha   = @invoice.fecha.to_date
         lcCode = @invoice.code.split("-")
         a = lcCode[0]
         b = lcCode[1]
         
        
        $lg_serie_factura = a  
        $lg_serial_id   = b.to_i
        $lg_serial_id2  = b
        puts b 
        puts $lg_serial_id 
        puts $lg_serial_id2 
        puts $lg_fecha 
        
        $lcRuc          = @invoice.customer.ruc
        
        $lcTd           = @invoice.document.descripshort
        
        $lcMail         = @invoice.customer.email
        $lcMail2        = ""
        $lcMail3        = ""
        
         legal_name_spaces = @invoice.customer.name.lstrip    
        
        if legal_name_spaces == nil
            $lcLegalName    = legal_name_spaces
        else
            $lcLegalName = @invoice.customer.name.lstrip    
        end
        $lcDirCli       = @invoice.customer.address1
        $lcDisCli       = @invoice.customer.address2
        $lcProv         = @invoice.customer.city
        $lcDep          = @invoice.customer.state
        
        ### detalle factura 
        
          
        for  invoiceitems in @invoiceitems 
        
        $lcCantidad     = invoiceitems.cantidad   
        lcPrecio =  invoiceitems.total   / invoiceitems.cantidad   
        lcPrecioSIGV = lcPrecio /1.18
        lcValorVenta = invoiceitems.total / 1.18
        lcTax = invoiceitems.total - lcValorVenta
        
        $lcPrecioCigv1  =  lcPrecio * 100
        
        $lcPrecioCigv2   = $lcPrecioCigv1.round(0).to_f
        $lcPrecioCigv   =  $lcPrecioCigv2.to_i 

        $lcPrecioSigv1  =  lcPrecioSIGV * 100
        $lcPrecioSigv2   = $lcPrecioSigv1.round(0).to_f
        $lcPrecioSIgv   =  $lcPrecioSigv2.to_i 
        
        $lcVVenta1      =  lcValorVenta * 100        
        $lcVVenta       =  $lcVVenta1.round(0)
            
        $lcIgv1         =  lcTax * 100
        $lcIgv          =  $lcIgv1.round(0)
        
        $lcTotal1       =  invoiceitems.total * 100
        $lcTotal        =  $lcTotal1.round(0)
        end 
        #@clienteName1   = Client.where("vcodigo = ?",params[ :$lcClienteInv ])        
        $lcClienteName = ""
      if invoiceitems != nil   
        $lcDes1   = invoiceitems.product.name 
      else
        $lcDes1 = ""
        
      end 
        $lcMoneda = @invoice.moneda_id
        
        #$lcGuiaRemision ="NRO.CUENTA BBVA BANCO CONTINENTAL : 0244-0100023293"
        $lcGuiaRemision = ""
        $lcPlaca = ""
        $lcDocument_serial_id =    $lg_serial_id
        #$lcAutorizacion =""
        #$lcAutorizacion1=""
   
        $lcSerie = a 
        $lcruc = "20555691263" 
        
        if $lcTd == 'FT'
            $lctidodocumento = '01'
        end
        if $lcTd =='BV'
            $lctidodocumento = '03'
        end 
        if $lcTd == 'NC'
            $lctidodocumento = '07'
        end 
        if $lcTd == 'ND'
            $lctidodocumento = '06'
        end
        if @invoice.document.descripshort == "FT"
          $lcTipoDocCli =  "1"
        else
          $lcTipoDocCli =  "6"
        end 
         $lcNroDocCli =@invoice.customer.ruc 
         
         $lcFecha1codigo      = $lg_fecha.to_s

          parts = $lcFecha1codigo.split("-")
          $aa = parts[0]
          $mm = parts[1]        
          $dd = parts[2]       
        $lcFechaCodigoBarras = $aa << "-" << $mm << "-" << $dd
        $lcIGVcode = $lcIgv
        $lcTotalcode = $lcTotal
        
        
        $lcCodigoBarra = $lcruc << "|" << $lcTd << "|" << $lcSerie << "|" << $lcDocument_serial_id.to_s << "|" <<$lcIGVcode.to_s<< "|" << $lcTotalcode.to_s << "|" << $lcFechaCodigoBarras << "|" << $lcTipoDocCli  << "|" << $lcNroDocCli
        
            $lcPercentIgv  =18000   
          $lcAutorizacion="Autorizado mediante Resolucion de Intendencia Nro.034-005-0005592/SUNAT del 22/06/2016 "
          $lcCuentas=" El pago del documento sera necesariamente efectuado mediante deposito en cualquiera de las siguientes cuentas bancarias:  
  BBVA Continental Cuenta Corriente en Moneda Nacional Numero: 0011-0172-01-00041266
  BBVA Continental Cuenta Corriente en Moneda Extranjera Numero: 0011-0176-01-00063164 
BCP Cuenta Corriente Moneda Nacional : 191-2167239-0-01
BCP Cuenta Recaudadora Moneda Nacional : 191-2264838-0-49"  


          $lcScop1       =""   
          $lcScop2       =""
          $lcCantScop1   =""
          $lcCantScop2   =""  
          $lcAutorizacion1=$lcAutorizacion +$lcCuentas  
      end # colateral 

  end

  # GET /invoices/new
  # GET /invoices/new.xml
  
  def new
    @pagetitle = "Nueva factura"
    @action_txt = "Create"
    $lcAction="Boleta"
    $Action= "create"
    
    @invoice = Factura.new
    
    @invoice[:code] = "#{generate_guid11()}"
    
    @invoice[:processed] = false
    @invoice[:descuento] = "0"
    @invoice[:tipoventa_id] = 1
    
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @products = @company.get_products()
    @tarjetas = Tarjetum.all
    @tipoventas = Tipoventum.all 
    
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    
    if @current_user.level== "colateral"
      @tipodocumento = @company.get_documents2()
    else 
      @tipodocumento = @company.get_documents()
    end
    
    @tipoventas = Tipoventum.all 
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
    @invoice[:moneda_id] = 2
    @invoice[:document_id] = 3
    
  end
  def new2
    @pagetitle = "Nueva factura"
    @action_txt = "Create"
    $lcAction="Factura"
    
    @invoice = Factura.new
    @invoice[:code] = "#{generate_guid3()}"
    @invoice[:processed] = false
    
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tipodocumento = @company.get_documents()
    @tipoventas = Tipoventum.all 
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
  end
  
  def new3
      
    @pagetitle = "Nueva factura"
    @action_txt = "Create"
    $lcAction="Factura"
    
    @invoice = Factura.new
    @invoice[:code] = "#{generate_guid3()}"
    @invoice[:processed] = false
    
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    @customers = @company.get_customers() 
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tipodocumento = @company.get_documents()
    @tipoventas = Tipoventum.all 
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
  end
  
  
  
def newfactura2
    
    @company = Company.find(1)
    @factura = Factura.find(params[:factura_id])
    @customer = Customer.find(params[:customer_id]) 
    @customer_name = @customer.name
    @customer_code = @customer.account 
    
    @detalleitems =  Sellvale.where(processed:"0",cod_cli: @customer.account,td:"N").order(:fecha)
    @factura_detail = Factura.new

  
  end 


  # GET /invoices/1/edit
  def edit
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
    @ac_customer = @invoice.customer.name
    @ac_user = @invoice.user.username
    @payments = @company.get_payments()    
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @products_lines = @invoice.products_lines
    @tipoventas = Tipoventum.all 
    @tipodocumento = @company.get_documents()
    @monedas = @company.get_monedas()
    @products = @company.get_products()
    @tarjetas = Tarjetum.all
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @pagetitle = "Nueva factura "
    @action_txt = "Create"
    
    items = params[:items].split(",")

    items2 = params[:items2].split(",")

    @invoice = Factura.new(factura_params)
    @company = Company.find(params[:factura][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments  = @company.get_payments()    
    @services  = @company.get_services()
    @products = @company.get_products()
    @tipoventas = Tipoventum.all 
    @tipodocumento = @company.get_documents()
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tarjetas = Tarjetum.all
   
    @invoice[:subtotal] = @invoice.get_total_1(items) / 1.18
    @invoice[:total]   = @invoice.get_total_1(items) 
    begin
      @invoice[:tax] = @invoice[:total] - @invoice[:subtotal]
    rescue
      @invoice[:tax] = 0
    end
    if @invoice[:tipoventa_id] ==  "1"
        @invoice[:balance] = 0
    else
        @invoice[:balance] = @invoice[:total]
    end 
    
    @invoice[:pago]    = 0
    @invoice[:charge]  = 0
    @invoice[:descuento] = "1"
    
     parts = (@invoice[:code]).split("-")
     id = parts[0]
     numero2 = parts[1]
     
    if(params[:factura][:user_id] and params[:factura][:user_id] != "")
      curr_seller = User.find(params[:factura][:user_id])
      @ac_user = curr_seller.username
    end
    @invoice[:numero2] = numero2
  
    respond_to do |format|
      if @invoice.save
        # Create products for kit
        @invoice.add_products(items)
        @invoice.add_guias(items2)
        if $lcAction == "Boleta"
          @invoice.correlativo2
        else
          @invoice.correlativo
        end 
        # Check if we gotta process the invoice
        @invoice.process()

        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @invoice = Factura.find(params[:id])
    @company = @invoice.company
    @payments = @company.get_payments()    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @invoice.customer.name
    end
    
    @products_lines = @invoice.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @tipoventas = Tipoventum.all 
    @tarjetas = Tarjetum.all
    
    @invoice[:subtotal] = @invoice.get_subtotal(items)
    @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id])
    @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]

    respond_to do |format|
      if @invoice.update_attributes(factura_params)
        # Create products for kit
        @invoice.delete_products()
        @invoice.add_products(items)
        @invoice.correlativo
        # Check if we gotta process the invoice
        @invoice.process()
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Factura.find(params[:id])
    company_id = @invoice[:company_id]
    if @invoice.destroy
      @invoice.delete_guias()
      @invoice.delete_facturas()
    end   


    respond_to do |format|
      format.html { redirect_to("/companies/facturas/" + company_id.to_s) }
    end

  end
  
  def exportxls
  
    $lcxCliente ="1"
    @company=Company.find(1)      
    
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]      
    lcmonedadolares ="1"
    lcmonedasoles ="2"
    @facturas_rpt = @company.get_pendientes_cliente(@fecha1,@fecha2,@cliente)    
    
    @total_cliente_dolares   = @company.get_pendientes_day_customer(@fecha1,@fecha2, @cliente, lcmonedadolares)
    @total_cliente_soles = @company.get_pendientes_day_customer(@fecha1,@fecha2, @cliente,lcmonedasoles)
    @total_cliente_detraccion = @company.get_pendientes_day_customer_detraccion(@fecha1,@fecha2, @cliente)
    puts @total_cliente_soles
    
    case params[:print]
      when "To PDF" then 
          redirect_to :action => "rpt_ccobrar3_pdf", :format => "pdf", :fecha1 => params[:fecha1], :fecha2 => params[:fecha2], :customer_id => params[:customer_id] 
      when "To Excel" then render xlsx: 'rpt_ccobrar3_xls'
        
      else render action: "index"
    end
  end
  
# reporte completo
  def build_pdf_header_rpt(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10

      end
    
      pdf 
  end   

  def build_pdf_body_rpt(pdf)
    
    pdf.text "Facturas Moneda" +" Emitidas : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    pdf.text ""
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Factura::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcGalones = 0
      lcGalones1 = 0
      galones = 0
      lcsubtotal =  0
      lctax = 0
      lctotal = 0
      lcCliente = @facturas_rpt.first.customer_id 
      

      lcmonedasoles   = 2
      lcmonedadolares = 1
  
     
      @total_original_soles =0
      @total_original_dolares =0
      @total_cliente_soles = 0
      @total_cliente_dolar = 0
      @total_cliente_cantidad = 0
      
      @totalvencido_soles = 0
      @totalvencido_dolar = 0
      total_soles = 0
      total_dolares = 0 
      precio_ultimo = 0
       for  product in @facturas_rpt
         
           
          if lcCliente == product.customer_id

            fechas2 = product.fecha2 

            row = []          
            if product.document 
              row << product.document.descripshort 
            else
              row <<  lcDoc 
            end 
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            
            dias_vencido = (product.fecha2.to_date - Date.today).to_i 
            
            row << dias 
            row << dias_vencido 
            row << product.customer.name.truncate(35, omission: ' ')
            
            if product.get_cantidad > 0
                precio_ultimo = product.total / product.get_cantidad
            else
                precio_ultimo = 0 
            end 
            row << sprintf("%.2f",(precio_ultimo.round(2)).to_s)            
            row << product.get_cantidad
            @total_cliente_qty    +=product.get_cantidad
            
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                
                if product.document_id   == 2
                  row << "0.00 "
                  row << sprintf("%.2f",(product.total*-1).to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  
                  
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                    
                else  
                  row << "0.00 "
                  row << sprintf("%.2f",product.total.to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                end   
                @total_cliente_dolar +=product.balance
            else
                if product.document_id == 2
                  row << sprintf("%.2f",(product.total*-1).to_s)
                  row << "0.00 "
                    
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance*-1
                  end  
                else                
                  row << sprintf("%.2f",product.total.to_s)
                  row << "0.00 "
                  
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
                  end  
                    
                end 
                
                @total_cliente_soles  +=product.balance
                
                
            end
            
            
            if product.detraccion == nil
              row <<  "0.00"
            else  
              row << sprintf("%.2f",product.detraccion.to_s)
            end
            
            row << product.get_vencido 
            table_content << row
            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""
            row << ""
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << sprintf("%.2f",@total_cliente_qty.to_s)
            row << " "
            row << " "
            row << " "
            
            row << sprintf("%.2f",@total_cliente_soles.to_s)
            row << sprintf("%.2f",@total_cliente_dolar.to_s)                      
            row << " "
            row << " "
            
            
            total_soles += @total_cliente_soles
            total_dolares += @total_cliente_dolar 
            
            @total_cliente_soles = 0
            @total_cliente_dolar = 0    
            @total_cliente_qty   = 0    
           
            table_content << row

            lcCliente = product.customer_id


            row = []          
            row << lcDoc
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            dias_vencido = (product.fecha2.to_date - Date.today).to_i 
            
            row << dias 
            row << dias_vencido  
            row << product.customer.name
            
            
            if product.get_cantidad > 0
                precio_ultimo = product.total / product.get_cantidad
            else
                precio_ultimo = 0 
            end 
            row << sprintf("%.2f",(precio_ultimo.round(2)).to_s)            
            row << product.get_cantidad
            row << product.moneda.symbol  
            @total_cliente_qty    +=product.get_cantidad
            
              if product.moneda_id == 1 
                if product.document_id   == 2
                  row << "0.00 "
                  row << sprintf("%.2f",(product.total*-1).to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                else  
                  row << "0.00 "
                  row << sprintf("%.2f",product.total.to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                end   
                @total_cliente_dolar += product.balance 
            else
                if product.document_id == 2
                  row << sprintf("%.2f",(product.total*-1).to_s)
                  row << "0.00 "
                    
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance*-1
                  end  
                else                
                  row << sprintf("%.2f",product.total.to_s)
                  row << "0.00 "
                  
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
                  end  
                    
                end 
                @total_cliente_soles += product.balance 
            end
            if product.detraccion == nil
              row <<  "0.00"
            else  
              row << sprintf("%.2f",product.detraccion.to_s)
            end
            
            row << product.get_vencido 
            
            
            table_content << row

          end 
          
        
          
        end

            lcCliente = @facturas_rpt.last.customer_id 
            totals = []            
            total_cliente = 0

            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            
                if product.document_id   == 2
                  
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                else  
                      @totalvencido_dolar += product.balance
            
                end
            
            @totalvencido_soles += product.balance
            @total_cliente_qty    +=product.get_cantidad
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""  
            row << ""  
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << sprintf("%.2f",@total_cliente_qty.to_s)
            row << " "
            row << " "
            row << " "
            
            row << sprintf("%.2f",@total_cliente_soles.to_s)
            row << sprintf("%.2f",@total_cliente_dolar.to_s)                      
            row << " "
            row << " "
            
            table_content << row
            
            
         total_soles   += @total_cliente_soles
         total_dolares += @total_cliente_dolar
         
         @total_cliente_soles = 0
         @total_cliente_dolar = 0    
          
         
         
         @totalvencido_soles = 0
         @totalvencido_dolar = 0    
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << ""  
          row << ""  
          row << "TOTALES => "
          row << ""
          row << " "
          row << " "
          row << " "
          row << " "
                
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          row << " "
            
          table_content << row
          end 
          

          result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width,
                                        :cell_style => { size: 6 },
                                        
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:left 
                                          columns([5]).width =30
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([8]).align=:right
                                          columns([8]).width =40
                                          columns([9]).align=:right
                                          columns([9]).width =40
                                          columns([10]).align=:right
                                          columns([10]).width =40
                                          columns([11]).align=:right
                                          columns([11]).width =40
                                          columns([12]).align=:right
                                          columns([13]).align=:right
                                        end                                          
                                        
      pdf.move_down 10    
      
      precio_ultimo = 0
      
      if $lcxCliente == "1" 
      
      totalxvencer_soles  = total_cliente_dolares   - @totalvencido_soles
      totalxvencer_dolar  = total_cliente_soles - @totalvencido_dolar
      
      pdf.table([  ["Resumen    "," Soles  ", "Dólares "],
              ["Total Vencido    ",sprintf("%.2f",@totalvencido_soles.to_s), sprintf("%.2f",@totalvencido_dolar.to_s)],
              ["Total por Vencer ",sprintf("%.2f",totalxvencer_soles.to_s),sprintf("%.2f",totalxvencer_dolar.to_s)],
              ["Totales          ",sprintf("%.2f",total_cliente_dolares.to_s),sprintf("%.2f",total_cliente_soles.to_s)]])
              
      end 
      #totales 
      
      pdf 

    end

       

    def build_pdf_footer_rpt(pdf)
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]
      end

      pdf
   end    
   

##### reporte de pendientes de pago..

  def build_pdf_header_rpt2(pdf)
       pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10

      end


      
      pdf 

  end   

  def build_pdf_body_rpt2(pdf)
    
    pdf.text "Cuentas por cobrar  : desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s , :size => 8 
    pdf.text ""
    pdf.font "Helvetica" , :size => 7

      headers = []
      table_content = []

      Factura::TABLE_HEADERS2.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

     table_content << headers

      nroitem = 1
      lcmonedasoles   = 2
      lcmonedadolares = 1
  
      lcDoc='FT'    
      
      lcCliente = @facturas_rpt.first.customer_id 
      
      @total_original_soles =0
      @total_original_dolares =0
      @total_cliente_soles = 0
      @total_cliente_dolar = 0
      
      @totalvencido_soles = 0
      @totalvencido_dolar = 0
      total_soles = 0
      total_dolares = 0 
      precio_ultimo = 0
       for  product in @facturas_rpt
       
         if product.balance.round(2) > 0.00
           
          if lcCliente == product.customer_id

            fechas2 = product.fecha2 

            row = []          
            if product.document 
              row << product.document.descripshort 
            else
              row <<  lcDoc 
            end 
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            
            dias_vencido = (product.fecha2.to_date - Date.today).to_i 
            
            row << dias 
            row << dias_vencido 
            row << product.customer.name.truncate(35, omission: ' ')
            
            if product.get_cantidad > 0
                precio_ultimo = product.total / product.get_cantidad
            else
                precio_ultimo = 0 
            end 
            row << sprintf("%.2f",(precio_ultimo.round(2)).to_s)            
            row << product.get_cantidad
            
            row << product.moneda.symbol  

            if product.moneda_id == 1 
                
                if product.document_id   == 2
                  row << "0.00 "
                  row << sprintf("%.2f",(product.total*-1).to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  
                  
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                    
                else  
                  row << "0.00 "
                  row << sprintf("%.2f",product.total.to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                end   
                @total_cliente_dolar +=product.balance
            else
                if product.document_id == 2
                  row << sprintf("%.2f",(product.total*-1).to_s)
                  row << "0.00 "
                    
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance*-1
                  end  
                  
                else                
                  row << sprintf("%.2f",product.total.to_s)
                  row << "0.00 "
                  
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
                  end  
                    
                end 
                
                if product.document_id == 2
                    @total_cliente_soles  +=product.balance*-1
                else
                    @total_cliente_soles  +=product.balance
                end 
                
            end
            
            
            if product.detraccion == nil
              row <<  "0.00"
            else  
              row << sprintf("%.2f",product.detraccion.to_s)
            end
            
            row << product.get_vencido 
            table_content << row
            nroitem = nroitem + 1

          else
            totals = []            
            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""
            row << ""
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << " "
            row << " "
            row << " "
            row << " "
            
            row << sprintf("%.2f",@total_cliente_soles.to_s)
            row << sprintf("%.2f",@total_cliente_dolar.to_s)                      
            row << " "
            row << " "
            
            
            total_soles += @total_cliente_soles
            total_dolares += @total_cliente_dolar 
            
            @total_cliente_soles = 0
            @total_cliente_dolar = 0    
          
           
            table_content << row

            lcCliente = product.customer_id


            row = []          
            row << lcDoc
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << product.fecha2.strftime("%d/%m/%Y")
            dias = (product.fecha2.to_date - product.fecha.to_date).to_i 
            dias_vencido = (product.fecha2.to_date - Date.today).to_i 
            
            row << dias 
            row << dias_vencido  
            row << product.customer.name.truncate(35, omission: ' ')
            
            
            if product.get_cantidad > 0
                precio_ultimo = product.total / product.get_cantidad
            else
                precio_ultimo = 0 
            end 
            row << sprintf("%.2f",(precio_ultimo.round(2)).to_s)            
            row << product.get_cantidad
            row << product.moneda.symbol  
            
              if product.moneda_id == 1 
                if product.document_id   == 2
                  row << "0.00 "
                  row << sprintf("%.2f",(product.total*-1).to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  
                    if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance*-1
                    end  
                else  
                  row << "0.00 "
                  row << sprintf("%.2f",product.total.to_s)
                    
                  row << "0.00 "
                  row << sprintf("%.2f",product.balance.to_s)
                  
                  if(product.fecha2 < Date.today)   
                      @totalvencido_dolar += product.balance
                  end  
                end   
                @total_cliente_dolar += product.balance 
            else
                if product.document_id == 2
                  row << sprintf("%.2f",(product.total*-1).to_s)
                  row << "0.00 "
                    
                  row << sprintf("%.2f",(product.balance*-1).to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance*-1
                  end  
                else                
                  row << sprintf("%.2f",product.total.to_s)
                  row << "0.00 "
                  
                  row << sprintf("%.2f",product.balance.to_s)
                  row << "0.00 "
                  if(product.fecha2 < Date.today)   
                      @totalvencido_soles += product.balance
                  end  
                    
                end 
                if product.document_id == 2
                    @total_cliente_soles  +=product.balance*-1
                else
                    @total_cliente_soles  +=product.balance
                end 
                
            end
            if product.detraccion == nil
              row <<  "0.00"
            else  
              row << sprintf("%.2f",product.detraccion.to_s)
            end
            
            row << product.get_vencido 
            
            
            table_content << row

          end 
          
        end 
          
        end

            lcCliente = @facturas_rpt.last.customer_id 
            totals = []            
            total_cliente = 0

            total_cliente_soles   = 0
            total_cliente_soles   = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedadolares)
            total_cliente_dolares = 0
            total_cliente_dolares = @company.get_pendientes_day_customer(@fecha1,@fecha2, lcCliente, lcmonedasoles)
            
            
              
                
            
            row =[]
            row << ""
            row << ""
            row << ""
            row << ""  
            row << ""  
            row << ""  
            row << "TOTALES POR CLIENTE=> "            
            row << ""
            row << " "
            row << " "
            row << " "
            row << " "
            
            row << sprintf("%.2f",@total_cliente_soles.to_s)
            row << sprintf("%.2f",@total_cliente_dolar.to_s)                      
            row << " "
            row << " "
            
            table_content << row
            
            
         total_soles   += @total_cliente_soles
         total_dolares += @total_cliente_dolar
         
         @total_cliente_soles = 0
         @total_cliente_dolar = 0    
          
         
         
         @totalvencido_soles = 0
         @totalvencido_dolar = 0    
           if $lcxCliente == "0" 

          row =[]
          row << ""
          row << ""
          row << ""
          row << ""
          row << ""  
          row << ""  
          row << "TOTALES => "
          row << ""
          row << " "
          row << " "
          row << " "
          row << " "
                
          row << sprintf("%.2f",total_soles.to_s)
          row << sprintf("%.2f",total_dolares.to_s)                    
          row << " "
          row << " "
            
          table_content << row
          end 
          

          result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width,
                                        :cell_style => { size: 6 },
                                        
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:left 
                                          columns([5]).width =30
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([8]).align=:right
                                          columns([8]).width =40
                                          columns([9]).align=:right
                                          columns([9]).width =40
                                          columns([10]).align=:right
                                          columns([10]).width =40
                                          columns([11]).align=:right
                                          columns([11]).width =40
                                          columns([12]).align=:right
                                          columns([13]).align=:right
                                        end                                          
                                        
      pdf.move_down 10    
      
      precio_ultimo = 0
      
      if $lcxCliente == "1" 
      
      totalxvencer_soles  = total_cliente_dolares   - @totalvencido_soles
      totalxvencer_dolar  = total_cliente_soles - @totalvencido_dolar
      
      pdf.table([  ["Resumen    "," Soles  ", "Dólares "],
              ["Total Vencido    ",sprintf("%.2f",@totalvencido_soles.to_s), sprintf("%.2f",@totalvencido_dolar.to_s)],
              ["Total por Vencer ",sprintf("%.2f",totalxvencer_soles.to_s),sprintf("%.2f",totalxvencer_dolar.to_s)],
              ["Totales          ",sprintf("%.2f",total_cliente_dolares.to_s),sprintf("%.2f",total_cliente_soles.to_s)]])
              
      end 
      #totales 
      
      pdf 

    end

    def build_pdf_footer_rpt2(pdf)      
                  
      pdf.text "" 
      pdf.bounding_box([0, 20], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

    end

    pdf
      
  end


  # Export serviceorder to PDF
  def rpt_facturas_all_pdf

    $lcFacturasall = '1'

    @company=Company.find(params[:company_id])          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_facturas_day(@fecha1,@fecha2,@moneda)      

#    respond_to do |format|
#      format.html    
#      format.xls # { send_data @products.to_csv(col_sep: "\t") }
#    end 

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt(pdf)
        pdf = build_pdf_body_rpt(pdf)
        build_pdf_footer_rpt(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end
# Export serviceorder to PDF
  def rpt_facturas_all2_pdf

    $lcFacturasall = '0'
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:customer_id]     
    @moneda = params[:moneda_id]    

    @facturas_rpt = @company.get_facturas_day_cliente(@fecha1,@fecha2,@cliente)  

    if @facturas_rpt != nil 
    
        Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
            pdf.font "Helvetica"
            pdf = build_pdf_header_rpt(pdf)
            pdf = build_pdf_body_rpt(pdf)
            build_pdf_footer_rpt(pdf)
            $lcFileName =  "app/pdf_output/rpt_factura_all.pdf"              
        end     
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')
    
    end 
    
  end


  ###pendientes de pago 
  def rpt_ccobrar2_pdf
    $lcxCliente ="0"
    @company=Company.find(1)      
    
      @fecha1 = params[:fecha1]  
      @fecha2 = params[:fecha2]

    @company.actualizar_fecha2
    @company.actualizar_detraccion 

    @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  

    
    Prawn::Document.generate "app/pdf_output/rpt_pendientes.pdf", :page_layout => :landscape do |pdf|        
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)

        $lcFileName =  "app/pdf_output/rpt_pendientes.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_pendientes.pdf", :type => 'application/pdf', :disposition => 'inline')
  

  end
  
  ###pendientes de pago 
  def rpt_ccobrar3_pdf

    $lcxCliente ="1"
    @company=Company.find(1)      
    @company.actualizar_fecha2
    @company.actualizar_detraccion 
    
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]      
   
    @facturas_rpt = @company.get_pendientes_cliente(@fecha1,@fecha2,@cliente)  


    if @facturas_rpt.size > 0 

        
        Prawn::Document.generate "app/pdf_output/rpt_pendientes.pdf", :page_layout => :landscape do |pdf|        
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)

        $lcFileName =  "app/pdf_output/rpt_pendientes.pdf"              
    end     

    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_pendientes.pdf", :type => 'application/pdf', :disposition => 'inline')

    end 

  end
  
  ###pendientes de pago detalle

  def rpt_ccobrar4_pdf
      $lcxCliente ="0"
      @company=Company.find(params[:company_id])          
      @fecha1 = params[:fecha1]  
      @fecha2 = params[:fecha2]  
      @facturas_rpt = @company.get_pendientes_day(@fecha1,@fecha2)  
      
      Prawn::Document.generate("app/pdf_output/rpt_pendientes4.pdf") do |pdf|
          pdf.font "Helvetica"
          pdf = build_pdf_header_rpt4(pdf)
          pdf = build_pdf_body_rpt4(pdf)
          build_pdf_footer_rpt4(pdf)
          $lcFileName =  "app/pdf_output/rpt_pendientes4.pdf"              
      end     
      $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
      send_file("app/pdf_output/rpt_pendientes4.pdf", :type => 'application/pdf', :disposition => 'inline')
  
  end
  

  def client_data_headers_rpt
      client_headers  = [["Empresa  :", $lcCli ]]
      client_headers << ["Direccion :", $lcdir1]
      client_headers
  end

  def invoice_headers_rpt            
      invoice_headers  = [["Fecha : ",$lcHora]]    
      invoice_headers
  end
 def discontinue
    
    @facturasselect = Sellvale.find(params[:products_ids])

    for item in @facturasselect
        begin
          a = item.id
          b = Product.find_by(code: item.cod_prod)             
          
          descuento =  item.implista - item.importe.to_f
          
          precio_descto0 = item.importe.to_f / item.cantidad 
          precio_descto = precio_descto0.round(2)
          
          preciolista0 = item.implista / item.cantidad 
          preciolista  = preciolista0.round(2)
          
          new_invoice_detail = FacturaDetail.new(factura_id: $lcFacturaId  ,sellvale_id: item.id , product_id: b.id ,price:preciolista, price_discount: precio_descto, quantity: item.cantidad,total: item.importe)
          
          if new_invoice_detail.save
            a= Sellvale.find(item.id)
            a.processed ='1'
            a.save
          end 
        end              
    end
    
    @invoice = Factura.find($lcFacturaId)
    
    @invoice[:total] = @invoice.get_subtotal2.round(2)
    
    lcTotal = @invoice[:total]  / 1.18
    @invoice[:subtotal] = lcTotal.round(2)
    
    lcTax =@invoice[:total] - @invoice[:subtotal]
    @invoice[:tax] = lcTax.round(2)
    
    @invoice[:balance] = @invoice[:total]
    @invoice[:pago] = 0
    @invoice[:charge] = 0
    @invoice[:descuento] = "1"
    
    respond_to do |format|
      if @invoice.save
        # Create products for kit
        
                # Check if we gotta process the invoice
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
    
  end   

  def print_tk 
    
  end 

##ticket
  def build_header_tk(pdf)
     pdf.font "Helvetica" , :size => 8
     
      pdf.text ".INVERSIONES VALUEMI S.A.C."  , :size => 8,  :style => :bold
      pdf.text ".RUC.:" << @company.ruc   , :size => 8,  :style => :bold
      
      pdf.text ".Direccion :Cam. Sector Cruz del Norte I Z Mza. C ", :size => 8
      pdf.text ".Lote. 5 A.H. Proyecto Integral Alianza ", :size => 8
      pdf.text ".     (Antes Paradero Huarango 4km )", :size => 8
      pdf.text ".         (Ovalo Zapallal)", :size => 8
      pdf.text ".       LIMA-LIMA CARABAYLLO", :size => 8
      
      
    pdf.font "Helvetica" , :size => 8
    if @invoice.document_id == 1 
      pdf.text ".        F A C T U R A"
    end  
    if @invoice.document_id == 3 
      pdf.text ".       B O  L E T A "
    end   
    pdf.text ".     E L E C T R Ó N I C A "
    pdf.text ".No.: " <<  @invoice.code 
    
    if @invoice.document_id == 1 
      pdf.text ".Razón Social: " << @invoice.customer.name
      pdf.text".R.U.C.:"  << @invoice.customer.ruc
    end
    
    if @invoice.document_id == 3 
      pdf.text ".Cliente : " << @invoice.customer.name
    end
    
    pdf.text ".Fecha Emisión: " << @invoice.fecha.strftime("%d/%m/%Y")
    
    pdf.text ".Tipo Moneda: SOL  "
    pdf 
    
 
  end   

  def build_body_tk(pdf)
    
      headers = []
      table_content = []
    
    
      nroitem = 1
      
       for  product in @invoice.get_products_2 
            row = []          
            row << product.code
            row << product.name 
            row << sprintf("%.2f",product.total) 
            table_content << row
            
            
             if product.quantity > 1
               row = []        
               row << "( " << sprintf("%.2f",product.quantity) << " x " << sprintf("%.2f",product.price) << " )"
               row << ""
               row << ""
               table_content << row
             end 
            
            nroitem = nroitem + 1
        end
        result = pdf.table table_content,
                                      { :position => :left,
                                        :header => false,
                                        :width => 210
                                        } do 
                                          self.cells.borders = [] 
                                          columns([0]).align=:center
                                          
                                          columns([1]).align=:left
                                          
                                          columns([2]).align=:left
                                          columns([2]).width= 40
                                        end                       
                                        
                                        
            table_content1 = []
            row =[]
            row << "OP.GRAVADAS"
            row << "S/. "
            row << sprintf("%.2f",@invoice.subtotal) 
            table_content1 << row
            
              
            row =[]
            row << "OP.INAFECTAS"
            row << "S/."
            row << "0.00"
            table_content1 << row
            
            row =[]
            row << "IGV."
            row << "S/."
            row << sprintf("%.2f",@invoice.tax)
            table_content1 << row
            
            row =[]
            row << "TOTAL."
            row << "S/."
            row << sprintf("%.2f",@invoice.total)
            table_content1<< row
             
        result = pdf.table table_content1,
                                      {:position => :left,
                                        :header => true,
                                        :width => 210
                                        } do 
                                          self.cells.borders = [] 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          
                                        end                                     
                                        
        
          
      pdf.move_down 10                                  
      pdf.image open("https://chart.googleapis.com/chart?chs=120x120&cht=qr&chl=#{$lcCodigoBarra}&choe=UTF-8") 
      pdf.text Date.today.strftime("%d/%m/%Y") 
      pdf.text DateTime.now.to_s(:time)

      pdf 

end
    
        def sendsunat
        @invoice = Factura.find(params[:id])
        
                
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production 

        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")
        files_to_clean.each do |file|
          File.delete(file)
        end 
        
        if $lcMoneda == "D"
            
        else
        case_3 = InvoiceGenerator.new(1, 3, 1, $lg_serie_factura,@invoice.id).with_igv(true)
        end     
         @invoice[:processed] = "1"
        @invoice.process
        
        $lcGuiaRemision =""      
        @@document_serial_id =""
        $lg_serial_id=""

    end

    def print
        @invoice = Factura.find(params[:id])
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
        

        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production

        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")
        files_to_clean.each do |file|
          File.delete(file)
        end         
       if @invoice.document_id=="2"
        #   credit_note_data = { issue_date: Date.new($aa,$mm,$dd), id: $lcNumeroNota, customer: {legal_name:$lcLegalName , ruc:$lcRuc },
        #                      billing_reference: {id: $lcBillingReference, document_type_code: "01"},
        #                      discrepancy_response: {reference_id: $lcBillingReference, response_code: "09", description: $lcDescrip},
        #                      lines: [{id: "1", item: {id: "05", description: $lcDescrip2}, quantity: $lcCantidad, unit: 'GLL', 
        #                           price: {value: $lcPrecioSIgv}, pricing_reference: $lcPrecioCigv, tax_totals: [{amount: $lcIgv, type: :igv, code: "10"}], line_extension_amount:$lcVVenta }],
        #                      additional_monetary_totals: [{id: "1001", payable_amount: $lcVVenta}], tax_totals: [{amount: $lcIgv, type: :igv}], legal_monetary_total: $lcTotal}
        

        # credit_note = SUNAT::CreditNote.new(credit_note_data)

        # if credit_note.valid?                       
        #   credit_note.to_pdf    
           
        #   $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
        #   send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

        # else
          
        #   $aviso = "Invalid document, ignoring output: #{credit_note.errors.messages}"

        # end

           
       else        
           if $lcMoneda == "D"  
                $lcFileName=""
                case_49 = InvoiceGenerator.new(1,3,1,$lg_serie_factura,@invoice.id).with_different_currency2
              #  puts $lcFileName 
           else
               puts @invoice.id 
                case_3  = InvoiceGenerator.new(1,3,1,$lg_serie_factura,@invoice.id).with_igv2(true)
           end 
        end 
    
        
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName
                
        send_file("#{$lcFileName1}", :type => 'application/pdf', :disposition => 'inline')

        
        @@document_serial_id =""
        $aviso=""
    end 

        
    def sendmail      
        @invoice = Factura.find(params[:id])
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production

        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")
        files_to_clean.each do |file|
          File.delete(file)
        end 

        
        if $lcMoneda == "D"
            case_49 = InvoiceGenerator.new(7,49,5,$lg_serie_factura,@invoice.id).with_different_currency2(true)
        else
            case_3 = InvoiceGenerator.new(1, 3, 1,$lg_serie_factura,@invoice.id).with_igv3(true)
        end 
    
        $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName        
        $lcFile2    =File.expand_path('../../../', __FILE__)+ "/"+$lcFilezip
        
        ActionCorreo.bienvenido_email(@invoice).deliver
         $lcGuiaRemision =""
             

    end


    def download
        extension = File.extname(@asset.file_file_name)
        send_data open("#{@asset.file.expiring_url(10000, :original)}").read, filename: "original_#{@asset.id}#{extension}", type: @asset.file_content_type
    end

    def xml
        
        lib = File.expand_path('../../../lib', __FILE__)
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

        require 'sunat'
        require './config/config'
        require './app/generators/invoice_generator'
        require './app/generators/credit_note_generator'
        require './app/generators/debit_note_generator'
        require './app/generators/receipt_generator'
        require './app/generators/daily_receipt_summary_generator'
        require './app/generators/voided_documents_generator'

        SUNAT.environment = :production
        files_to_clean = Dir.glob("*.xml") + Dir.glob("./app/pdf_output/*.pdf") + Dir.glob("*.zip")

        files_to_clean.each do |file|
          File.delete(file)
        end         
         if $lcMoneda == "D"
            case_49 = InvoiceGenerator.new(7,49,5,$lg_serie_factura).with_different_currency2
        else
            case_3 = InvoiceGenerator.new(1, 3, 1, $lg_serie_factura).with_igv3(true)
        end 
        $lcFile2 =File.expand_path('../../../', __FILE__)+ "/"+$lcFilezip    
    
        send_file("#{$lcFile2}",:type =>'application/zip', :disposition => 'inline') 
        @@document_serial_id =""
        $aviso=""
    end 


  # reporte completo
  def build_pdf_header_rpt2(pdf)
      pdf.font "Helvetica" , :size => 8
     $lcCli  =  @company.name 
     $lcdir1 = @company.address1+@company.address2+@company.city+@company.state

     $lcFecha1= Date.today.strftime("%d/%m/%Y").to_s
     $lcHora  = Time.now.to_s

    max_rows = [client_data_headers_rpt.length, invoice_headers_rpt.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers_rpt.length >= row ? client_data_headers_rpt[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers_rpt.length >= row ? invoice_headers_rpt[rows_index] : ['',''])
      end

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do
          columns([0, 2]).font_style = :bold

        end

        pdf.move_down 10
      end      
      pdf 
  end   

def salidas(pdf)

    pdf.text "Listado de Salidas desde "+@fecha1.to_s+ " Hasta: "+@fecha2.to_s + "      Stock al : "+Date.today.strftime("%Y-%d-%m") , :size => 8 
     
    pdf.font "Helvetica" , :size => 6

      headers = []
      table_content = []

      Output::TABLE_HEADERS3.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers

      nroitem=1
      lcDoc='FT'
      lcMon='S/.'

      @totales = 0
      @cantidad = 0
      nroitem = 1

       for  product in @facturas_rpt
 
            row = []         
            row << nroitem.to_s
            row << product.code
            row << product.fecha.strftime("%d/%m/%Y")
            row << "" 
            row << product.nameproducto
            row << product.unidad 
            
            row << product.employee.full_name
            row << product.truck.placa            
            row << sprintf("%.2f",product.quantity.to_s)
            row << sprintf("%.2f",product.get_stock(product.product_id).to_s)
            row << sprintf("%.2f",product.price.to_s)

            calculartotal =product.price*product.quantity

            row << sprintf("%.2f",calculartotal.to_s)
          
            table_content << row

            @totales += calculartotal 
            @cantidad += product.quantity

            nroitem=nroitem + 1
       
        end
      
      row =[]
      row << ""
      row << ""
      row << ""
      row << ""
      row << ""
      
      row << ""
      row << ""
      
      row << "TOTALES => "
      row << sprintf("%.2f",@cantidad.to_s)
      row << " "
      row << " "
      row << sprintf("%.2f",@totales.to_s)


      table_content << row
      
      result = pdf.table table_content, {:position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
                                        } do 
                                          columns([0]).align=:center
                                          columns([1]).align=:left
                                          columns([2]).align=:left
                                          columns([2]).width = 45
                                          columns([3]).align=:left
                                          columns([4]).align=:left
                                          columns([5]).align=:center  
                                          columns([6]).align=:left
                                          columns([7]).align=:left
                                          columns([8]).align=:right
                                          columns([8]).width = 50
                                          columns([9]).align=:right
                                          columns([9]).width = 50
                                          columns([10]).align=:right
                                          columns([10]).width = 50
                                          columns([11]).align=:right
                                          columns([11]).width = 50
                                          
                                        end                                          
      pdf.move_down 10      
      #totales 
      pdf 

    end

    def build_pdf_footer_rpt2(pdf)
            data =[ ["Procesado por Programacion ","V.B.Administracion ","V.B. Gerente ."],
               [":",":",":"],
               [":",":",":"],
               ["Fecha:","Fecha:","Fecha:"] ]

           
            pdf.text " "
            pdf.table(data,:cell_style=> {:border_width=>1} , :width => pdf.bounds.width)
            pdf.move_down 10          

                        
      pdf.text "" 
      pdf.bounding_box([0, 30], :width => 535, :height => 40) do
      pdf.draw_text "Company: #{@company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]

      end

      pdf
      
  end


# Export serviceorder to PDF
  def rpt_salidas2_all_pdf

    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
  
    @facturas_rpt = @company.get_salidas_day4(@fecha1,@fecha2)

    Prawn::Document.generate("app/pdf_output/rpt_factura.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header_rpt2(pdf)
        pdf = build_pdf_body_rpt2(pdf)
        build_pdf_footer_rpt2(pdf)
        $lcFileName =  "app/pdf_output/rpt_factura.pdf"              
    end     
    $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName              
    send_file("app/pdf_output/rpt_factura.pdf", :type => 'application/pdf', :disposition => 'inline')

  end


  def rpt_ccobrar12_all 
    
    $lcxCliente = "1"
    @company=Company.find(1)      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @cliente = params[:customer_id]
    @banco = params[:bank_id]
    
    @ClienteDato = @company.get_cliente(@cliente)
    $lcNameCliente =@ClienteDato.name
    $lcRucCliente  =@ClienteDato.ruc

    @customer_rpt = @company.get_customer_payments_client_banco(@fecha1,@fecha2,@cliente,@banco)  
   
   
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Vale5 ",template: "customer_payments/rpt_ccobrar12_all.pdf.erb",locals: {:varillajes => @customer_rpt},
                  :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
               
               
        
        end   
      when "To Excel" then render xlsx: 'rpt_ccobrar12_all'
      else render action: "index"
    end
  end
  def reportes30 
    
    $lcxCliente = "1"
    @company=Company.find(1)      
    @fecha1 = params[:fecha1]
    @fecha2 = params[:fecha2]
    @banco_select = params[:cbox1]
    @banco = params[:bank_id]
    @tiporeporte = params[:tiporeporte]
    
    if @banco_select == "1"
      @customerpayment_rpt = @company.get_customer_payments_cabecera(@fecha1,@fecha2)  
      
    else
      
      @customerpayment_rpt = @company.get_customer_payments_cabecera2(@fecha1,@fecha2,@banco)  
    end 
    puts @banco_select
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "ReporteCancelaciones",template: "customer_payments/rpt_ccobrar13_all.pdf.erb",locals: {:varillajes => @customerpayment_rpt},
                  :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
        
        end   
      when "To Excel" then render xlsx: 'rpt_cobrar13_xls'
      else render action: "index"
    end
  end
  
 def rpt_redencion_1
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @customer = params[:customer_id]    
    
    @customer_name = @company.get_customer_name(@customer)
    
    @redencion_rpt = @company.get_redencion_1(@fecha1,@fecha2,@company.get_customer_account(@customer))
    
    
    case params[:print]
      when "To PDF" then 
        begin 
         render  pdf: "Ordenes ",template: "facturas/redencion1_rpt.pdf.erb",locals: {:redentions => @redencion_rpt},
        :header => {
           :spacing => 5,
                           :html => {
                     :template => 'layouts/pdf-header.html',
                           right: '[page] of [topage]'
                  }
               }
        
        end   
        
      else render action: "index"
    end
  end

def factura3 
  
    @company=Company.find(1)          
    @fecha1 = params[:fecha1]    
    @fecha2 = params[:fecha2]    
    @cliente = params[:cod_cli]    
    
    @customer = Customer.find_by(account: params[:cod_cli]  ) 
    @invoice = Factura.new
    @invoice[:code] = "#{generate_guid3()}"
    @invoice[:processed] = false
    
    
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    @payments = @company.get_payments()
    @services = @company.get_services()
    @deliveryships = @invoice.my_deliverys 
    @tipofacturas = @company.get_tipofacturas() 
    @monedas = @company.get_monedas()
    @tipodocumento = @company.get_documents()
    @tipoventas = Tipoventum.all 
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
    
    
   
    case params[:next]
      when "Continuar" then 
        begin 
            
            @detalleitems =  Sellvale.where(processed:"0",cod_cli: @customer.account,td:"N").order(:fecha)
            @factura_detail = Factura.new
        end   
        
      else render action: "index"
    end
  end

   
  
      
  private
  def factura_params
    params.require(:factura).permit(:company_id,:location_id,:division_id,:customer_id,:description,:comments,:code,:subtotal,:tax,:total,:processed,:return,:date_processed,:user_id,:payment_id,:fecha,:preciocigv,:tipo,:observ,:moneda_id,:detraccion,:factura2,:description,:document_id,:tipoventa_id,:tarjeta_id,:guia)
  end

end


