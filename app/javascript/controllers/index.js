// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ActivitySearchController from "./activity_search_controller"
application.register("activity-search", ActivitySearchController)

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import MapController from "./map_controller"
application.register("map", MapController)

import SubmitHoursController from "./submit_hours_controller"
application.register("submit-hours", SubmitHoursController)
