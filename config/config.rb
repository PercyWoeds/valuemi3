SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20514739065"
    c.username  = "GEYE2018"
    c.password  = "20514739065"
   end

  config.signature do |s|
    s.party_id    = "20514739065"
    s.party_name  = "GRUPO E & E S.A.C."
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificate1.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADO1.key') 
  end

  config.supplier do |s|
    s.legal_name = "GRUPO E & E S.A.C."
    s.name       = ""
    s.ruc        = "20514739065"
    s.address_id = "150106"
    s.street     = "AV. TUPAC AMARU KM. 22.5 LOTE. 7 URB. PUNCHAUCA "
    s.district   = "LIMA - LIMA - CARABAYLLO"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/app/assets/images/logo.PNG"
  
  end
end

