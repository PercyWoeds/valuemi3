class NoteConcept < ActiveRecord::Base
     validates_presence_of  :descrip ,:td

  belongs_to :document
end
