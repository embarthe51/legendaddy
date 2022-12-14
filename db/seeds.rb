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
user = User.new(
  email: "cooldude@gmail.com",
  password: "123456789",
  pseudo: "Legendaddy_du_93"
)
file = URI.open("https://res.cloudinary.com/wagon/image/upload/c_fill,g_face,h_200,w_200/v1670235617/tddm97ebcaysis1s2m5s.jpg")
user.photo.attach(io: file, filename: "franck.jpg", content_type: "image/jpg")
user.save!

user = User.new(
  email: "cooldad@gmail.com",
  password: "123456789",
  pseudo: "FrontEnd_dad"
)
file = URI.open("https://avatars.githubusercontent.com/u/74938003?v=4")
user.photo.attach(io: file, filename: "nico.jpg", content_type: "image/jpg")
user.save!

user = User.new(
  email: "daddycool@gmail.com",
  password: "123456789",
  pseudo: "Best_dad"
)
file = URI.open("https://res.cloudinary.com/wagon/image/upload/c_fill,g_face,h_200,w_200/v1665117611/xlgahjdus4ba2ulnokkx.jpg")
user.photo.attach(io: file, filename: "alban.jpg", content_type: "image/jpg")
user.save!

user = User.new(
  email: "juju@gmail.com",
  password: "123456789",
  pseudo: "legendad_2_b"
)
file = URI.open("https://avatars.githubusercontent.com/u/104355406?v=4")
user.photo.attach(io: file, filename: "julien.jpg", content_type: "image/jpg")
user.save!

user = User.new(
  email: "p_to_the_y@gmail.com",
  password: "123456789",
  pseudo: "la_legende_py"
)
file = URI.open("https://avatars.githubusercontent.com/u/8135012?v=4")
user.photo.attach(io: file, filename: "p_y.jpg", content_type: "image/jpg")
user.save!

puts "creating kids........."
Kid.create!(
  first_name: "Anna",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Lisa",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Laura",
  user: User.where(email: "cooldude@gmail.com").first
)

Kid.create!(
  first_name: "Denis",
  user: User.where(email: "daddycool@gmail.com").first
)

Kid.create!(
  first_name: 'Francesca',
  user: User.where(email: "cooldad@gmail.com").first
)

Kid.create!(
  first_name: 'Alicianna',
  user: User.where(email: "cooldad@gmail.com").first
)

Kid.create!(
  first_name: 'Pas_encore_n??',
  user: User.where(email: "juju@gmail.com").first
)

puts "Creating activities..."

url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=date_start%3A%5B2022-12-08T23%3A00%3A00Z+TO+2022-12-11T22%3A59%3A59Z%5D&rows=40&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Enfants&exclude.tags=Innovation&exclude.tags=Art+contemporain&exclude.tags=Spectacle+musical&exclude.tags=BD&exclude.tags=Concert&exclude.tags=Musique&exclude.tags=Sport&exclude.tags=Histoire&exclude.tags=Th%C3%A9%C3%A2tre"
activities_serialized = URI.open(url).read
activities = JSON.parse(activities_serialized)

activities["records"].each do |activity|
  next if activity["fields"]["lat_lon"].nil?
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

  file = URI.open(activity["fields"]["cover_url"].nil? ? "https://images.unsplash.com/photo-1491013516836-7db643ee125a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmFieXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60" : activity["fields"]["cover_url"])
  current_activity.photos.attach(io: file, filename: activity["fields"]["image_couverture"].nil? ? "filename" : activity["fields"]["image_couverture"]["filename"], content_type: activity["fields"]["image_couverture"].nil? ?  "image/jpeg" : activity["fields"]["image_couverture"]["mimetype"])
  current_activity.save!
end

activity = Activity.new(
  title: "Social bar",
  description: "bois une bi??re avec ton enfant! Un programme ??v??nementiel de folie ( karaoke, blindtests, concerts, improvisation, stand-up), un espace pour f??ter vos anniversaires, pots de d??parts, ou tout simplement vous retrouver entre coll??gues et ami.e.s. Nous proposons une carte tr??s diversifi??e ( bi??res, cocktails, tapas) et vous pouvez venir bruncher chaque samedi ?? partir de 12H00",
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
  description: "Palomano, la ville o?? les enfants font leurs lois !",
  url: "https://palomano.com/",
  price: "13???",
  address: "125 boulevard Jean Jaur??s, 92110 Clichy",
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
  description: "Lieu de vie & studio Yoga+Pilates Adulte, famille, enfant & b??b?? Ensemble ou pas !",
  url: "https://www.pomme-maisondefamille.com/",
  price: "20???",
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
  description: "un programme destin?? aux enfants et diffuse le meilleur des films d'animation, dont le culte Mon voisin Totoro de Hayao Miyazaki, tous les dimanches matins",
  url: "www.studiodesursulines.com",
  price: "9???",
  address: "10, rue des Ursulines, 75005 Paris",
  workshop: false,
  open_days: [0],
  open_hour: DateTime.new(2022, 12, 4, 9, 0, 0),
  closing_hour: DateTime.new(2022, 12, 4, 12, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)
activity.tag_list.add("Cin??ma")
file = URI.open("https://images.unsplash.com/photo-1519340241574-2cec6aef0c01?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80")
activity.photos.attach(io: file, filename: "baby_cinema.png", content_type: "image/png")
activity.save!

activity = Activity.new(
  title: "CIT?? DES ENFANTS 2-7 ANS",
  description: "La Cit?? des enfants 2-7 ans est ouverte ?? la petite enfance d??s 2 ans, et s'organise sur 1700 m?? d??coup??s en cinq espaces th??matiques : Je me d??couvre, Je sais faire, Je me rep??re, J'exp??rimente, Tous ensemble",
  url: "https://www.cite-sciences.fr/fr/au-programme/expos-permanentes/la-cite-des-enfants/cite-des-enfants-2-7-ans",
  price: "12???",
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
  description: "Piscine o?? vous pourrez pratiquer le b??b?? nageur avec votre petit(e). Attention, t??l??phonez pour vous assurer des disponibilit??s et qu'il ne faut pas r??server!",
  url: "https://www.paris.fr/lieux/piscine-pontoise-2918",
  price: "5???",
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
  description: "?? l'abordage ! Direction le parc de Belleville dans le 20e arrondissement pour partir ?? la d??couverte de la nouvelle aire de jeux inaugur??e en novembre 2019. ",
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
  title: "SOIR??E JEUX DE SOCI??T?? AVEC MAMYGEEK",
  description: "Jeux de soci??t?? pour tou.te.s, seul.e, en famille ou entre amis ! Jeux de rapidit??, jeux d'ambiance, jeux de strat??gie???",
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
activity.photos.attach(io: file, filename: "biblioth??que.png", content_type: "image/png")
activity.save!

Activity.where(latitude: nil).destroy_all

puts "creating availabilities.........................................................................."

Availability.create!(
  start_at: DateTime.new(2022, 12, 9, 9, 0, 0),
  end_at: DateTime.new(2022, 12, 9, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Availability.create!(
  start_at: DateTime.new(2022, 12, 10, 14, 0, 0),
  end_at: DateTime.new(2022, 12, 10, 18, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

Availability.create!(
  start_at: DateTime.new(2022, 12, 4, 9, 0, 0),
  end_at: DateTime.new(2022, 12, 4, 12, 0, 0),
  user: User.where(email: "cooldude@gmail.com").first
)

puts "creating some reviews.........................................................................."

Activity.all.each do |item|
  Review.create!(
    content: "Incroyable",
    rating: 5,
    user: User.where(email: "cooldude@gmail.com").first,
    activity: Activity.find(item.id)
  )
end

Activity.all.each do |item|
  Review.create!(
    content: "Nice!",
    rating: 4,
    user: User.where(email: "daddycool@gmail.com").first,
    activity: Activity.find(item.id)
  )
end

Activity.all.each do |item|
  Review.create!(
    content: "Bof",
    rating: 3,
    user: User.where(email: "cooldad@gmail.com").first,
    activity: Activity.find(item.id)
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

Review.create!(
  content: "Une piscine irreprochable. RAS",
  rating: 5,
  user: User.where(email: "p_to_the_y@gmail.com").first,
  activity: Activity.where(title: "Piscine Municipale de Pontoise").first
)

Review.create!(
  content: "TOP",
  rating: 5,
  user: User.where(email: "cooldad@gmail.com").first,
  activity: Activity.where(title: "Piscine Municipale de Pontoise").first
)

Review.create!(
  content: "Des cheveaux partout mais le staff nikel",
  rating: 3,
  user: User.where(email: "cooldad@gmail.com").first,
  activity: Activity.where(title: "Piscine Municipale de Pontoise").first
)

Review.create!(
  content: "Il ya du monde parfois.",
  rating: 5,
  user: User.where(email: "juju@gmail.com").first,
  activity: Activity.where(title: "Piscine Municipale de Pontoise").first
)

puts "Finished!"
