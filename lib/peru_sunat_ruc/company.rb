class PeruSunatRuc::Company
  attr_accessor :ruc_number,
                :name,
                :address,
                :taxpayer_type,
                :taxpayer_status,
                :taxpayer_condition,
                :inscription_date,
                :voucher_system,
                :accounting_system,
                :economic_activities,
                :affiliate_ple_since,
                :electronic_emisor,
                :activity_trade,
                :date_start_activities


  def initialize(data_hash = {})
    data_hash.each do|key, value|
      instance_variable_set "@#{key}", value
    end
  end
end