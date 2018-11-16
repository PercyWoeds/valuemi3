class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.string journal 
      t.integer nid_journal
      t.datetime ffecha_journal
      t.integer nid_surtidor
      t.integer nlado_surtidor
      t.integer nid_producto
      t.integer nposicion_manguera
      t.float dprecio_journal
      t.float dvolumen_journal
      t.float dmonto_journal
      t.float dcontometrogalon_journal
      t.float dcontometromoneda_journal
      t.datetime ffechacontable_journal
      t.turno nturno_journal
      t.string nestadodesp
      t.string nestadocont
      t.float ntransactionid_journal
      t.float ntranfinished_journal

      t.timestamps null: false
    end
  end
end
