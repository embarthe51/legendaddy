import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="submit-hours"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTargets.forEach((input) => {

      flatpickr(input, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
      });
    });
      // je target mes 6 input pour avoir un array
    // iteration sur mes input
    // sur chaque input j instancie un flatpickr
  }
}
