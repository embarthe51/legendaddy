import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="submit-hours"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log(this.inputTargets);
    this.inputTargets.forEach((input) => {

     new flatpickr(input, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        time_24hr: true,
      });
    });
      // je target mes 6 input pour avoir un array
    // iteration sur mes input
    // sur chaque input j instancie un flatpickr
  }
}
