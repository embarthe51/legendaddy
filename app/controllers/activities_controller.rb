class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    @filtered_activities = []
    @activities.each do |activity|
      if activity.workshop?
        current_user.availabilities.each do |availability|
          @filtered_activities << activity if availability.start_at <= activity.start_at && availability.end_at >= activity.end_at
        end
      end
    end
    @filtered_activities = @filtered_activities.uniq
  end

# si l'activite est un workshop

# comparer le start at et le end at du workshop avec les start_at et le end_at de availibility
# si c'est inclus alors on affiche l'activite

# si l'activite n'est pas un workshop
# comparer les jours d'ouverture avec les availibilities
# afficher les activities qui correspondent aux availabilities

# si aucune activite n'est incluse dans les availibities
# demander au cuser de selectionner d'autres dispo

  def show
    @activity = Activity.find(params[:id])
  end

end
