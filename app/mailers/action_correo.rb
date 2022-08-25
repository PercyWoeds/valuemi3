class ActionCorreo < ApplicationMailer
  	  default from: 'factura-electronica@valuemiperu.com'


	  def bienvenido_email(invoice)
		  @invoices=invoice 			
		   @url  = 'http://www.apple.com'
		  #attachments["Factura"] = File.read("#{$lcFileName1}")
		  #attachments['Factura'] = File.read($lcFileName1)

		  email_with_name = "Factura Enviada <factura-electronica@valuemiperu.com>, <programacion@valuemiperu.com>"	
		  email_with_copy = "Administracion <administracion@valuemiperu.com>"	
		  attachments[$lcFileName] =  open($lcFileName1).read

		  attachments[$lcFilezip] =  open($lcFile2).read

		  mail(to: [$lcMail,$lcMail2,$lcMail3], cc: email_with_copy,   bcc:email_with_name, subject: 'Factura Electrónica : '+$lcFileNameIni )


	  end


	  def notify_followers(mail,user)
		   @user=user			
		   @url  = 'http://www.kinzuko.com.pe'
		
        

		  email_with_name = "Reporte Personal <percywoeds@gmail.com>"	
		 
		   


		  mail(to: [mail], cc:email_with_name, subject: 'Account Reports : ' )

	  end

	  def notify_followers2(mail,user,compro)
		   @user=user		
		   @comprobante = compro 	
		   @url  = 'http://www.valuemi.com.pe'
		
        
         
		  email_with_name = "Cuentas por pagar <percywoeds@gmail.com>"	
		 
		   


		  mail(to: [mail], cc:email_with_name, subject: 'Anulacion de Comprobante CCPP : ' )

	  end

end
