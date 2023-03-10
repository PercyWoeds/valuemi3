SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20514739065"
    c.username  = "GEYE2018"
    c.password  = "20514739065"
   end

  config.signature do |s|
    s.party_id    = "20501683109"
    s.party_name  = "CONSORCIO KINZUKO S.A.C"
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificategee.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADOGEE.key') 
  end

  config.supplier do |s|
    s.legal_name = "CONSORCIO KINZUKO S.A.C."
    s.name       = ""
    s.ruc        = "20501683109"
    s.address_id = "150106"
    s.street     = "MZA. J LOTE. 19 URB. BRISAS DE STA ROSA (GRIFO REPSOL)"
    s.district   = "SAN MARTIN DE PORRES - LIMA-LIMA"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/app/assets/images/logo.jpg"

  
  end
end

