require "open-uri"
require "json"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Cleaning database..."
Message.destroy_all
Convo.destroy_all
Review.destroy_all
Activity.destroy_all
Availability.destroy_all
Kid.destroy_all
User.destroy_all

puts "creating users..."
User.create!(
  email: "cooldude@gmail.com",
  password: "123456789"
)

User.create!(
  email: "cooldad@gmail.com",
  password: "123456789"
)

User.create!(
  email: "daddycool@gmail.com",
  password: "123456789"
)

puts "creating kids........."
Kid.create!(
  first_name: "Etta",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Greta",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Thunberg",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Denis",
  user: User.where(email: "daddycool@gmail.com").first
)

puts "Creating activities..."

url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&rows=40&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Enfants"
activities_serialized = URI.open(url).read
activities = JSON.parse(activities_serialized)

activities["records"].each do |activity|
  next if activity["fields"]["lat_lon"].nil?
  next if activity["fields"]["title"] == "CinéKids - décembre 2022"
  next if activity["fields"]["title"] == "Atelier d'éveil musical 'Les tambours du monde'"
  next if activity["fields"]["description"].nil?
  next if activity["fields"]["date_start"].nil?
  next if activity["fields"]["date_end"].nil?

  current_activity = Activity.new(
    title: activity["fields"]["title"],
    description: activity["fields"]["description"],
    url: activity["fields"]["url"],
    price: activity["fields"]["price_type"],
    address: Geocoder.search(activity["fields"]["lat_lon"]).first.address,
    user: User.where(email: "cooldude@gmail.com").first
  )

  if (activity["fields"]["tags"].split(";").any? {
    |tag| /atelier/.match?(tag.downcase)
  })
    current_activity.workshop = true
    current_activity.start_at = DateTime.parse(activity["fields"]["date_start"])
    current_activity.end_at = DateTime.parse(activity["fields"]["date_end"])
  else
    current_activity.open_days = [0, 1, 2, 3, 4, 5, 6]
    current_activity.open_hour = DateTime.parse(activity["fields"]["date_start"])
    current_activity.closing_hour = DateTime.parse(activity["fields"]["date_end"])
  end

  activity["fields"]["tags"].split(";").each do |tag|
    current_activity.tag_list.add(tag) unless /Enfants/.match?(tag)
  end

  # current_activity.tag_list.add(activity["fields"]["tags"])
  file = URI.open(activity["fields"]["cover_url"].nil? ? "https://images.unsplash.com/photo-1491013516836-7db643ee125a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmFieXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60" : activity["fields"]["cover_url"])
  current_activity.photos.attach(io: file, filename: activity["fields"]["image_couverture"].nil? ? "filename" : activity["fields"]["image_couverture"]["filename"], content_type: activity["fields"]["image_couverture"].nil? ?  "image/jpeg" : activity["fields"]["image_couverture"]["mimetype"])
  current_activity.save!
end

activity = Activity.new(
  title: "Social bar",
  description: "bois une bière avec ton enfant!",
  url: "https://www.social-bar.org/paris/",
  address: "25, rue Villiot, 75012 Paris",
  workshop: false,
  open_days: [0, 1, 2, 3, 4, 5],
  open_hour: DateTime.new(2022, 1, 1, 12, 0, 0),
  closing_hour: DateTime.new(2022, 1, 1, 23, 59, 0),
  user: User.where(email: "cooldude@gmail.com").first,
)
activity.tag_list.add("Bar")
file = URI.open("https://images.unsplash.com/photo-1533777419517-3e4017e2e15a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80")
activity.photos.attach(io: file, filename: "drinking_beer.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "Palomano",
  description: "Palomano, la ville où les enfants font leurs lois !",
  url: "https://palomano.com/",
  price: "13€",
  address: "125 boulevard Jean Jaurès, 92110 Clichy",
  workshop: true,
  start_at: DateTime.new(2022, 12, 5, 12, 0, 0),
  end_at: DateTime.new(2022, 12, 5, 13, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Atelier")
file = URI.open("https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YmFieSUyMGJvc3N8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60")
activity.photos.attach(io: file, filename: "baby_painting.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "Pomme",
  description: "Lieu de vie & studio Yoga+Pilates Adulte, famille, enfant & bébé Ensemble ou pas !",
  url: "https://www.pomme-maisondefamille.com/",
  price: "20€",
  address: "4 rue Euryale Dehaynin 75019 Paris",
  workshop: true,
  start_at: DateTime.new(2022, 12, 9, 12, 0, 0),
  end_at: DateTime.new(2022, 12, 9, 13, 0, 0),
  user: User.where(email: "cooldad@gmail.com").first
)
activity.tag_list.add("Atelier", "Yoga")
file = URI.open("https://images.unsplash.com/photo-1617268604962-a2878c372cc7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJhYnklMjB5b2dhfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60")
activity.photos.attach(io: file, filename: "baby_yoga.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "Le Studio des Ursulines",
  description: "un programme destiné aux enfants et diffuse le meilleur des films d'animation, dont le culte Mon voisin Totoro de Hayao Miyazaki, tous les dimanches matins",
  url: "www.studiodesursulines.com",
  price: "9€",
  address: "10, rue des Ursulines, 75005 Paris",
  workshop: false,
  open_days: [0],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 12, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Cinéma")
file = URI.open("https://images.unsplash.com/photo-1519340241574-2cec6aef0c01?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80")
activity.photos.attach(io: file, filename: "baby_cinema.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "CITÉ DES ENFANTS 2-7 ANS",
  description: "La Cité des enfants 2-7 ans est ouverte à la petite enfance dès 2 ans, et s'organise sur 1700 m² découpés en cinq espaces thématiques : Je me découvre, Je sais faire, Je me repère, J'expérimente, Tous ensemble",
  url: "https://www.cite-sciences.fr/fr/au-programme/expos-permanentes/la-cite-des-enfants/cite-des-enfants-2-7-ans",
  price: "12€",
  address: "30 Avenue Corentin Cariou 75019 Paris France",
  workshop: false,
  open_days: [0,2, 3, 4, 5, 6],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Sciences")
file = URI.open("https://images.unsplash.com/photo-1575364289437-fb1479d52732?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cGxheXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60")
activity.photos.attach(io: file, filename: "baby_playing.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "Piscine Municipale de Pontoise",
  description: "Piscine où vous pourrez pratiquer le bébé nageur avec votre petit(e). Attention, téléphonez pour vous assurer des disponibilités et qu'il ne faut pas réserver!",
  url: "https://www.paris.fr/lieux/piscine-pontoise-2918",
  price: "5€",
  address: " Rue de Pontoise, 75005 Paris",
  workshop: false,
  open_days: [1, 2, 3, 4, 5, 6, 0],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 17, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Piscine")
file = URI.open("https://plus.unsplash.com/premium_photo-1661290345523-feb44424e6a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmFieSUyMHN3aW1taW5nfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60")
activity.photos.attach(io: file, filename: "baby_swiming.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "Sensations fortes au parc de Belleville",
  description: "À l'abordage ! Direction le parc de Belleville dans le 20e arrondissement pour partir à la découverte de la nouvelle aire de jeux inaugurée en novembre 2019. ",
  url: "https://www.paris.fr/pages/top-des-aires-de-jeux-les-plus-ludiques-de-la-capitale-18795",
  price: "gratuit",
  address: "47 rue des Couronnes 75020 PARIS",
  workshop: false,
  open_days: [1, 2, 3, 4, 5, 6, 0],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Balade")
file = URI.open("https://cdn.paris.fr/paris/2021/10/04/original-0964ef6c14fc01d0f61e884d85b9769f.jpg")
activity.photos.attach(io: file, filename: "baby_parc.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "SOIRÉE JEUX DE SOCIÉTÉ AVEC MAMYGEEK",
  description: "Jeux de société pour tou.te.s, seul.e, en famille ou entre amis ! Jeux de rapidité, jeux d'ambiance, jeux de stratégie…",
  url: "https://www.paris.fr/equipements/bibliotheque-sorbier-1753",
  price: "gratuit",
  address: "17 rue Sorbier 75020 Paris",
  workshop: false,
  open_days: [1, 2, 3, 4, 5, 6, 0],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Loisirs")
file = URI.open("https://cdn.paris.fr/qfapv4/2021/12/01/huge-e0c0dc7170a6f85ddebd45987b37292c.jpg")
activity.photos.attach(io: file, filename: "bibliothèque.png", content_type: "image/png")
activity.save!

puts "creating availabilities.........................................................................."

Availability.create!(
  start_at: DateTime.new(2022, 12, 2, 9, 0, 0),
  end_at: DateTime.new(2022, 12, 2, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Availability.create!(
  start_at: DateTime.new(2022, 12, 5, 12, 0, 0),
  end_at: DateTime.new(2022, 12, 5, 13, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Availability.create!(
  start_at: DateTime.new(2022, 12, 4, 9, 0, 0),
  end_at: DateTime.new(2022, 12, 4, 12, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

puts "creating some reviews.........................................................................."
<<<<<<< HEAD
=======

>>>>>>> c5ba81755e8c9972fb86f0c0ba42403dae4ffb5e
Activity.all.each do |item|
  Review.create!(
    content: "Incroyable",
    rating: 5,
    user: User.where(email: "cooldude@gmail.com").first,
<<<<<<< HEAD
    activity: Activity.where(id: item.id)
=======
    activity: Activity.find(item.id)
>>>>>>> c5ba81755e8c9972fb86f0c0ba42403dae4ffb5e
  )
end

Review.create!(
  content: "Incroyable",
  rating: 4,
  user: User.where(email: "cooldude@gmail.com").first,
  activity: Activity.where(title: "Social bar").first
)

Review.create!(
  content: "cool",
  rating: 4,
  user: User.where(email: "cooldude@gmail.com").first,
  activity: Activity.where(title: "Palomano").first
)

Review.create!(
  content: "great!",
  rating: 5,
  user: User.where(email: "cooldude@gmail.com").first,
  activity: Activity.where(title: "Social bar").first
)

Review.create!(
  content: "Franchement bof.",
  rating: 2,
  user: User.where(email: "cooldude@gmail.com").first,
  activity: Activity.where(title: "Social bar").first
)

puts "Finished!"
