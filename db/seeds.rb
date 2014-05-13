# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ad = Admin.new
ad.email = 'admin@kelma.org'
ad.password, ad.password_confirmation = 'KelmaAdmin@123'
ad.save