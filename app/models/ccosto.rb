class Ccosto < ActiveRecord::Base
    belongs_to :employee
     validates_presence_of :name 
     validates_uniqueness_of :code 
end
