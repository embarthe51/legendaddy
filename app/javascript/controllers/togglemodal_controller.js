import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="togglemodal"
export default class extends Controller {
  static targets = [ "arrow", "modal" ]

  slideopen() {
    // toggle la classe sur la fleche
    this.arrowTarget.classList.toggle("activated")
    this.modalTarget.classList.toggle("activated")
    // toggle la classe sur la modale
  }
}
