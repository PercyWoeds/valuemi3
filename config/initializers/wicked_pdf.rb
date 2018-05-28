# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
if Rails.env.staging? || Rails.env.production?
  exe_path = Rails.root.join('bin', 'wkhtmltopdf').to_s
else
  exe_path = Rails.root.join('bin', 'wkhtmltopdf').to_s
  # exe_path = '/usr/local/bin/wkhtmltopdf'
end