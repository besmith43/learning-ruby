# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Experience.destroy_all

40.times do | index |
    
    Experience.create(
        owner: 1,
        start_date: Faker::Date.birthday(1, 25),
        end_date: Faker::Date.birthday(1, 25),
        name: Faker::Company.name,
        description: Faker::Company.profession
        )
    
end

=begin
Experience.create([
    {
        owner: 1,
        start_date: "August 2016",
        end_date: "Present",
        name: "TTU",
        description: "Professor and Chair"
    },
    {
        owner: 1,
        start_date: "August 2011",
        end_date: "July 2016",
        name: "Miami University - Oxford",
        description: "Professor"
    },
    {
        owner: 1,
        start_date: "August 2010",
        end_date: "July 2016",
        name: "Miami University - Oxford",
        description: "Director, Mobile Learning Center"
    },
    {
        owner: 1,
        start_date: "August 2006",
        end_date: "July 2010",
        name: "Miami University - Oxford",
        description: "Associate Professor"
    },
    {
        owner: 1,
        start_date: "August 2004",
        end_date: "July 2006",
        name: "Arizona State University Polytechnic",
        description: "Assistant Professor"
    },
    {
        owner: 1,
        start_date: "August 1998",
        end_date: "July 2004",
        name: "Arizona State University",
        description: "Assistant Professor"
    },
    {
        owner: 1,
        start_date: "August 1994",
        end_date: "July 1998",
        name: "NASA Jet Propulsion Laboratory",
        description: "Graduate Student Research Fellow"
    },
    {
        owner: 1,
        start_date: "August 2013",
        end_date: "July 2014",
        name: "Suncorp Group",
        description: "Solution Architect"
    },
    {
        owner: 1,
        start_date: "January 1992",
        end_date: "July 1992",
        name: "Unisys Corporation",
        description: "Software Engineer"
    },
    {
        owner: 1,
        start_date: "August 1988",
        end_date: "July 1990",
        name: "IBM Corporation, Rochester",
        description: "Software Developer"
    }
])
=end

p "Created #{Experience.count} entries."