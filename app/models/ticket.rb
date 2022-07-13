class Ticket < ActiveRecord::Base

	validates_presence_of :fecha, :cantidad
  
end
