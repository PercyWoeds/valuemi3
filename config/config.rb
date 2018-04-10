SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20555691263"
    c.username  = "FACTURA2"
    c.password  = "20555691263"
   end

  config.signature do |s|
    s.party_id    = "20555691263"
    s.party_name  = "INVERSIONES VALUEMI S.A.C."
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificado2.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADO2.key') 
  end

  config.supplier do |s|
    s.legal_name = "INVERSIONES VALUEMI S.A.C."
    s.name       = "Cesar Jaime Manrique Milla"
    s.ruc        = "20555691263"
    s.address_id = "150106"
    s.street     = "CAM.SECTOR CRUZ DEL NORTE I ZONA BAJA MZA. C LOTE. 5
    A.H. PROYECTO INTEGRAL ALIANZA INDUSTRIAL DE LAS LOMAS "
    s.district   = "LIMA - LIMA - CARABAYLLO"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/app/assets/images/logo.PNG"
  
  end
end

