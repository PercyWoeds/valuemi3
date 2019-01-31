class AddTurnoToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :turno, :integer
  end
end
