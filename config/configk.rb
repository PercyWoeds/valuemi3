SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20504809090"
    c.username  = "KINGAS22"
    c.password  = "20504809090"
   end

  config.signature do |s|
    s.party_id    = "20504809090"
    s.party_name  = "KINGAS S.A.C."
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificategee.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADOGEE.key') 
  end

  config.supplier do |s|
    s.legal_name = "KINGAS S.A.C."
    s.name       = ""
    s.ruc        = "20504809090"
    s.address_id = "150106"
    s.street     = "OTR.PARCELA E KM. 9.8 MZA. A1 LOTE. 1 C.C. COMUNIDAD CAMPESINA DE LLANAVILLA  PACHACAMAC LIMA"
    s.district   = "PACHACAMAC - LIMA-LIMA"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/app/assets/images/logo-primax.png"
  
  end
end

