# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
rooms = Room.create([{name: 'Hang Out'}, {name: 'Chill Out'}])
users = User.create([{name: 'Jane', email: 'jane@test.com', password: 'jane'},
                     {name: 'John', email: 'jon@test.com', password: 'jon'}])
