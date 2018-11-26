class Journal < ActiveRecord::Base
    
    
     def self.to_csv
    attributes = %w{id  journal nid_journal ffecha_journal nid_surtidor nlado_surtidor  nid_producto nposicion_manguera dprecio_journal dvolumen_journal 
    dmonto_journal dcontometrogalon_journal dcontometromoneda_journal ffechacontable_journal turno  nturno_journal nestadodesp nestadocont ntransactionid_journal
    ntranfinished_journal}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end



end
