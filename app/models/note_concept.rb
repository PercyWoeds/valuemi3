class NoteConcept < ActiveRecord::Base
    
    validates_presence_of  :descrip,:document_id ,:td

  belongs_to :documentv
end
