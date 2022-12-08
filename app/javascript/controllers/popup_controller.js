import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popup"
export default class extends Controller {
  static targets = ["container", "trigger"]

  connect() {
  }

  toggle(event) {
    event.preventDefault();
    this.containerTarget.classList.toggle("active");
  }

  close(event) {
    if (!this.triggerTarget.contains(event.target)) {
      if(!(this.containerTarget.contains(event.target)) && this.containerTarget.classList.contains("active")) {
        this.containerTarget.classList.remove("active");
      };
    }
  }
}
