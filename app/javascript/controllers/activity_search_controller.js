import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activity-search"
export default class extends Controller {
  static targets = ['form', 'activities', 'map']
  connect() {

  }

  search(event) {
    const url = this.formTarget.action
    const data = new FormData(this.formTarget)
    const options = {
      body: data,
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    }
    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        this.activitiesTarget.innerHTML = data.html
        this.mapTarget.innerHTML = data.map_html
      })
  }
}
