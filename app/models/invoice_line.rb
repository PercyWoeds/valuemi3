  class InvoiceLine
    include Model 
  
    
    property :id,                     String
    property :quantity,               Quantity
    property :line_extension_amount,  PaymentAmount    # total
    property :price,                  PaymentAmount    # price
    property :pricing_reference,      PricingReference # list price with tax
    property :item,                   Item
    
    
    validates :id, :quantity, :line_extension_amount, :price, :pricing_reference, :tax_totals, :item, presence: true
    
    KNOWN_UNIT_CODES = {
      :product => "NIU",
      :service => "ZZ"
    }

    TABLE_HEADERS = ["ITEM",
                     "CANTIDAD",
                     "UNIDAD",
                     "DESCRIPCION",
                     "PRECIO UNITARIO",
                     "VALOR UNITARIO",
                     "VALOR TOTAL"]




    def build_pdf_table_row(pdf)
      row = []
      row << self.id
      row << self.quantity.quantity
      row << self.quantity.unit_code
      row << "#{self.item.description} - #{self.item.id}"
      row << "#{self.pricing_reference.alternative_condition_price.price_amount.to_s}"
      row << "#{self.price.to_s}"
      row << "#{self.line_extension_amount.to_s}"
    end

    protected

    def parse_attributes(attrs = {})
      handle_item(attrs)
      handle_quantity(attrs)
      handle_total(attrs)
      handle_list_price(attrs)
      attrs
    end
    
    private

    def handle_item(attrs)
      desc = attrs.delete(:description)
      if desc
        self.item = {
          description: desc,
          id: attrs.delete(:code)
        }
      end
    end

    def handle_quantity(attrs)
      qty  = attrs.delete(:quantity)
      unit = attrs.delete(:unit)
      if qty
        code = if unit.is_a?(Symbol) and real_code = KNOWN_UNIT_CODES[unit]
          real_code
        else
          unit
        end
        self.quantity = {quantity:qty, unit_code:code}
      end
    end

    def handle_total(attrs)
      price = attrs.delete(:total)
      if price
        self.line_extension_amount = price
      end
    end

    # Essentially all this does is forward list_price to the 
    # pricing_reference property.
    def handle_list_price(attrs)
      price = attrs.delete(:list_price)
      if price
        self.pricing_reference = price
      end
    end
   
end
