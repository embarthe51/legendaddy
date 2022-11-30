# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Cleaning database..."
Activity.destroy_all
Availability.destroy_all
User.destroy_all

puts "creating the user..."
User.create(
  email: "cooldude@gmail.com",
  password: "123456789"
)

puts "Creating activities..."

Activity.create(
  title: "Social bar",
  description: "drink a beer with your kid",
  url: "https://www.social-bar.org/paris/",
  address: "25, rue Villiot, 75012 Paris",
  workshop: false,
  open_days: 012345,
  open_hour: DateTime.new(2022, 1, 1, 12, 0, 0),
  closing_hour: DateTime.new(2022, 1, 1, 1, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
Activity.create!(
  title: "Palomano",
  description: "Palomano, la ville où les enfants font leurs lois !",
  url: "https://palomano.com/",
  price_cents: 13,
  address: "125 boulevard Jean Jaurès, 92110 Clichy",
  workshop: true,
  start_at: DateTime.new(2022, 12, 5, 12, 0, 0),
  end_at: DateTime.new(2022, 12, 5, 13, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Availability.create!(
  start_at: DateTime.new(2022, 12, 5, 12, 0, 0),
  end_at: DateTime.new(2022, 12, 5, 13, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Activity.create!(
  title: "Le Studio des Ursulines",
  description: "un programme destiné aux enfants et diffuse le meilleur des films d'animation, dont le culte Mon voisin Totoro de Hayao Miyazaki, tous les dimanches matins",
  url: "www.studiodesursulines.com",
  price_cents: 9,
  address: "10, rue des Ursulines, 75005 Paris",
  workshop: false,
  open_days: 0,
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 12, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Activity.create!(
  title: "CITÉ DES ENFANTS 2-7 ANS",
  description: "La Cité des enfants 2-7 ans est ouverte à la petite enfance dès 2 ans, et s'organise sur 1700 m² découpés en cinq espaces thématiques : Je me découvre, Je sais faire, Je me repère, J'expérimente, Tous ensemble",
  url: "https://www.cite-sciences.fr/fr/au-programme/expos-permanentes/la-cite-des-enfants/cite-des-enfants-2-7-ans",
  price_cents: 12,
  address: "30 Avenue Corentin Cariou 75019 Paris France",
  workshop: false,
  open_days: 234560,
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Activity.create!(
  title: "Piscine Municipale de Pontoise",
  description: "Piscine où vous pourrez pratiquer le bébé nageur avec votre petit(e). Attention, téléphonez pour vous assurer des disponibilités et qu'il ne faut pas réserver!",
  url: "https://www.paris.fr/lieux/piscine-pontoise-2918",
  price_cents: 5,
  address: " Rue de Pontoise, 75005 Paris",
  workshop: false,
  open_days: 1234560,
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 17, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

puts "Finished!"
