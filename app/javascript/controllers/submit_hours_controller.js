import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="submit-hours"
export default class extends Controller {
  static targets = ["input", "form"]
  static values = {
    date: String
  }

  connect() {
    const currentTabId = window.location.search.split('=')[1]

    if (currentTabId) {
      document.getElementById(currentTabId).click()
    }


    this.inputTargets.forEach((input) => {
      console.log(input)
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

  displayForm() {
    console.log(this.formTargets);
    this.formTargets.classList.toggle("d-none");
  }
}
