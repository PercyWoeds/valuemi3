class AddCodigoToInvoicesunat < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :codigo, :string
  end
end
