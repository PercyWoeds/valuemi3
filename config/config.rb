
SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20514739065"
    c.username  = "GEYE2018"
    c.password  = "20514739065"
   end

  config.signature do |s|
    s.party_id    = "20514739065"
    s.party_name  = "GRUPO E & E S.A.C."
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificategee.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADOGEE.key') 
  end

  config.supplier do |s|
    s.legal_name = "GRUPO E & E S.A.C."
    s.name       = ""
    s.ruc        = "20514739065"
    s.address_id = "150132"
    s.street     = "AV. TUPAC AMARU KM. 22.5 LOTE. 7 URB. PUNCHAUCA
    (ALT.PARADERO LAS AMERICAS LT8)"
    s.district   = "CARABAYLLO - LIMA - LIMA   "
    #s.city       = "LOCAL: AV. CERRO DE PASCO NRO. 253 (A DOS CDAS DEL MUNICIPIO)
    #PASCO - PASCO - PAUCARTAMBO"
    s.city       = ""
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/app/assets/images/logo-primax.png"
  
                          
                          
  end
end

