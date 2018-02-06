class Remision < ActiveRecord::Base
      self.per_page = 20
  
  validates_presence_of :descrip 

end
