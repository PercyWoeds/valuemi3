include UsersHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :checkUserInfo
  
  require 'barby'
  require 'barby/barcode'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'
  
  require 'prawn/measurement_extensions'
require 'prawn/qrcode'

 def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end
  
	private
	def current_cart
	Cart.find(session[:cart_id])
	rescue ActiveRecord::RecordNotFound
	cart = Cart.create
	session[:cart_id] = cart.id
	cart
	end

	
end
