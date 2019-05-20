module SUNAT

  class Quantity
    include Model

    property :quantity,   Float
    property :unit_code,  String # unit codes as defined in UN/ECE rec 20
    def build_xml(xml, tag_name)
      xml['cbc'].send(tag_name, { unitCode: $lcUnidad20 }, quantity)
    end
  end
end
