require "open-uri"
require "json"

url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Enfants"
activities_serialized = URI.open(url).read
activities = JSON.parse(activities_serialized)
# puts DateTime.parse(activities["records"].first["fields"]["date_start"])


# activities["records"].each do |activity|
#   current_activity = Activity.new(
#     title: activity["fields"]["title"],
#     description: activity["fields"]["description"],
#     url: activity["fields"]["url"],
#     price_cents: activity["fields"]["price_detail"],
#     address: activity["fields"]["address_street"],
#     open_days: [0, 1, 2, 3, 4, 5, 6],
#     open_hour: DateTime.new["fields"]["date_start"],
#     closing_hour: DateTime.new["fields"]["date_end"],
#     user: User.where(email: "cooldude@gmail.com").first,
#   )
#   current_activity.tag_list.add["tags"]
#   file = URI.open["cover_url"]
#   current_activity.photos.attach(io: file, filename:["image_couverture"]["filename"], content_type: ["image_couverture"]["mimetype"])
#   current_activity.save!

# end

Activity.all.each do |item|
  Review.create!(
    content: "Incroyable",
    rating: 5,
    user: User.where(email: "cooldude@gmail.com").first,
    activity: Activity.where(id: item.id)
  )
end
