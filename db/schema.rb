# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161201152045) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
  end

  add_index "addresses", ["customer_id"], name: "index_addresses_on_customer_id"

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "website"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.string   "ruc"
  end

  create_table "company_users", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "comments"
    t.string   "account"
    t.string   "taxable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "ruc"
  end

  create_table "declaration_deliveries", force: :cascade do |t|
    t.integer  "delivery_id"
    t.integer  "declaration_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "declarations", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.integer  "punto_id"
    t.integer  "punto2_id"
    t.integer  "truck_id"
    t.integer  "truck2_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.text     "observacion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processes"
    t.string   "return"
    t.datetime "date_processes"
    t.integer  "user_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.integer  "employee_id"
    t.integer  "empsub_id"
    t.integer  "subcontrat_id"
    t.integer  "truck_id"
    t.integer  "truck2_id"
    t.integer  "address_id"
    t.integer  "remision"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "processed"
    t.integer  "division_id"
    t.float    "i"
  end

  create_table "delivery_services", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "price"
    t.integer  "quantity"
    t.integer  "unidad_id"
    t.integer  "peso"
    t.float    "discount"
    t.float    "total"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "deliveryships", force: :cascade do |t|
    t.integer  "factura_id"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email1"
    t.string   "email2"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "licencia"
    t.string   "full_name"
  end

  create_table "facturas", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "fecha"
    t.string   "serie"
    t.string   "numero"
    t.string   "payment_id"
    t.integer  "factura_id"
  end

  create_table "guia", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.integer  "truck_id"
    t.integer  "employee_id"
    t.integer  "empsub_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "guia_services", force: :cascade do |t|
    t.integer  "service_id"
    t.float    "price"
    t.integer  "quantity"
    t.integer  "unidad_id"
    t.integer  "peso"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "Delivery_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.text     "description"
    t.text     "comments"
    t.integer  "category_id"
    t.float    "logicalStock"
    t.float    "physicalStock"
    t.float    "cost"
    t.float    "total"
    t.string   "processed"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "date1"
  end

  create_table "inventory_details", force: :cascade do |t|
    t.integer  "inventory_id"
    t.integer  "product_id"
    t.float    "logicalStock"
    t.float    "physicalStock"
    t.float    "cost"
    t.float    "price"
    t.float    "totallogical"
    t.float    "totalphysical"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "invoice2s", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "invoice_products", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "product_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_services", force: :cascade do |t|
    t.integer  "invoice2_id"
    t.integer  "service_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "factura_id"
    t.float    "preciocigv"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
  end

  create_table "kits_products", force: :cascade do |t|
    t.integer  "product_kit_id"
    t.integer  "product_id"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 1
    t.integer  "order_id"
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "website"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manifests", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "solicitante"
    t.datetime "fecha1"
    t.string   "telefono1"
    t.integer  "camionetaqty"
    t.integer  "camionetapeso"
    t.integer  "camionqty"
    t.integer  "camionpeso"
    t.integer  "semiqty"
    t.integer  "semipeso"
    t.integer  "extenqty"
    t.integer  "extenpeso"
    t.integer  "camaqty"
    t.integer  "camapeso"
    t.integer  "modularqty"
    t.integer  "modularpeso"
    t.integer  "punto_id"
    t.integer  "punto2_id"
    t.datetime "fecha2"
    t.string   "contacto1"
    t.string   "contacto2"
    t.string   "telefono2"
    t.text     "especificacion"
    t.float    "largo"
    t.float    "ancho"
    t.float    "alto"
    t.integer  "peso"
    t.integer  "bultos"
    t.string   "otros"
    t.text     "observa"
    t.text     "observa2"
    t.integer  "company_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "marcas", force: :cascade do |t|
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modelos", force: :cascade do |t|
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.integer  "user_id"
    t.string   "ruc"
  end

  create_table "packages", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.float    "price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "companies"
    t.integer  "locations"
    t.integer  "users"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "title_clean"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "internal_type"
    t.integer  "vendor_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "hidden",        default: 0
    t.integer  "hidden_by"
    t.boolean  "cash"
    t.boolean  "change"
    t.boolean  "unpaid"
    t.boolean  "quote"
    t.integer  "position"
    t.integer  "company_id"
    t.datetime "hidden_at"
  end

  create_table "payments", force: :cascade do |t|
    t.string   "descrip"
    t.text     "comment"
    t.integer  "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "category"
    t.integer  "supplier_id"
    t.float    "cost"
    t.float    "price"
    t.string   "tax1_name"
    t.float    "tax1"
    t.string   "tax2_name"
    t.float    "tax2"
    t.string   "tax3_name"
    t.float    "tax3"
    t.integer  "quantity"
    t.integer  "reorder"
    t.text     "description"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.float    "discount"
    t.float    "CurrTotal"
    t.integer  "i"
    t.float    "price2"
    t.string   "status"
  end

  create_table "products_categories", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_kits", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "pumps", force: :cascade do |t|
    t.string   "fuel"
    t.string   "pump01"
    t.integer  "tank_id"
    t.integer  "product_id"
    t.float    "price_buy"
    t.float    "price_sell"
    t.float    "le_an_gln"
    t.float    "le_ac_gln"
    t.float    "gln"
    t.datetime "date1"
    t.integer  "employee_id"
    t.string   "turno"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "puntos", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_details", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "unit_id"
    t.float    "price_with_tax"
    t.float    "price_without_tax"
    t.float    "price_public"
    t.float    "quantity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "totaltax"
    t.float    "totaltax2"
    t.float    "discount"
    t.float    "total"
    t.integer  "purchase_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.string   "tank_id"
    t.string   "integer"
    t.integer  "document_type_id"
    t.string   "document"
    t.datetime "date1"
    t.datetime "date2"
    t.float    "exchange"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.float    "price_with_tax"
    t.float    "price_without_tax"
    t.float    "price_public"
    t.float    "quantity"
    t.integer  "other"
    t.string   "money_type"
    t.float    "discount"
    t.float    "tax1"
    t.float    "payable_amount"
    t.float    "tax_amount"
    t.float    "total_amount"
    t.string   "status"
    t.string   "pricestatus"
    t.float    "charge"
    t.float    "payment"
    t.float    "balance"
    t.float    "tax2"
    t.integer  "supplier_id"
    t.string   "order1"
    t.integer  "plate_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.text     "comments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
  end

  create_table "restocks", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "supplier_id"
    t.integer  "quantity"
    t.datetime "when"
    t.string   "received"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "code"
    t.string   "already_processed"
  end

  create_table "services", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.float    "cost"
    t.float    "price"
    t.string   "tax1_name"
    t.float    "tax1"
    t.integer  "quantity"
    t.text     "description"
    t.text     "comments"
    t.integer  "company_id"
    t.float    "discount"
    t.float    "currtotal"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "i"
    t.float    "total"
    t.integer  "peso"
    t.integer  "unidad_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.integer  "user_id"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "subcontrats", force: :cascade do |t|
    t.string   "ruc"
    t.string   "name"
    t.string   "address1"
    t.string   "distrito"
    t.string   "provincia"
    t.string   "dpto"
    t.string   "pais"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "ruc",        limit: 11
    t.string   "taxable"
  end

  create_table "tanks", force: :cascade do |t|
    t.string   "comments"
    t.integer  "product_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tanks", ["company_id"], name: "index_tanks_on_company_id"
  add_index "tanks", ["product_id"], name: "index_tanks_on_product_id"

  create_table "trucks", force: :cascade do |t|
    t.string   "code"
    t.string   "placa"
    t.string   "clase"
    t.integer  "marca_id"
    t.integer  "modelo_id"
    t.string   "certificado"
    t.integer  "ejes"
    t.string   "licencia"
    t.string   "neumatico"
    t.string   "config"
    t.string   "carroceria"
    t.integer  "anio"
    t.string   "estado"
    t.string   "propio"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "unidads", force: :cascade do |t|
    t.string   "descrip"
    t.float    "valorconversion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_packages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "companies"
    t.integer  "locations"
    t.integer  "users"
  end

  create_table "voideds", force: :cascade do |t|
    t.string   "serie"
    t.string   "numero"
    t.string   "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
