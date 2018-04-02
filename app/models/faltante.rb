class Faltante < ActiveRecord::Base
    validates_presence_of :fecha,:total 
    
    belongs_to :employee
    belongs_to :tipofaltante
end
