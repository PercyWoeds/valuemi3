# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@free_package = Package.new     

#if free_package.new_record?
  @free_package.title = 'Free'
  @free_package.slug = 'free'
  @free_package.price = 0
  @free_package.description = 'Free Package'
  @free_package.companies = 1
  @free_package.locations = 1
  @free_package.users = 1
  @free_package.save
#end


@v = Voided.new
@v.serie ='001'
@v.numero='1'
@v.save

@v = Voided.new
@v.serie ='001'
@v.numero='1'
@v.save

@v = Voided.new
@v.serie ='001'
@v.numero='1'
@v.save

@v = Moneda.new
@v.description="DOLARES"
@v.symbol= "US$"
@v.company_id =1
@v.save

@v = Moneda.new
@v.description= "SOLES"
@v.symbol= "S/."
@v.company_id= 1
@v.save

@c =Company.new
@c.user_id= 4
@c.name= "GRUPO EYE - MARKET"
@c.address1= "CARABAYLLO"
@c.address2= "LIMA"
@c.city= "LIMA"
@c.state= "LIMA"
@c.zip= "92"
@c.country= "Peru", 
@c.website= "http://www.grupoeye.com.pe"
@c.save

@l =Location.new
@l.company_id= 1
@l.name="LIMA"
@l.address1= "CARABAYLLO"
@l.address2= "LIMA"
@l.city= "LIMA"
@l.state= ""
@l.country= "Peru"
@l.save
@l.company_id= 1

 @d =Division.new
 @d.company_id= 1 
 @d.location_id= 1 
 @d.name= "ADMINISTRACION" 
 @d.description= "ADMINISTRACION"
@d.save

@d =Division.new
 @d.company_id= 1 
 @d.location_id= 1 
 @d.name= "COMPRAS" 
 @d.description= "COMPRAS"
@d.save


@d =Division.new
 @d.company_id= 1 
 @d.location_id= 1 
 @d.name= "OPERACIONES" 
 @d.description= "OPERACIONES"
@d.save


@u=User.new
@u.username= "percywoeds"
@u.level= "admin"
@u.first_name= "percy"
@u.last_name= "woeds",
@u.email= "percywoeds@gmail.com"
@u.password= "ycrep2016"
@u.password_confirmation = "ycrep2016"

@u.save

@c=CompanyUser.new
@c.company_id= 1
@c.user_id= 1
@c.save




