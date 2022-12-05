import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="convo-subscription"
export default class extends Controller {
  static values = { convoId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ConvoChannel", id: this.convoIdValue },
      { received: data => this.#insertAndScroll(data) },
    )
  }
  #insertAndScroll(data) {
    this.messagesTarget.insertAdjacentHTML('beforeend', data)
    window.scrollTo(0, this.messagesTarget.scrollHeight)
  }
  resetForm(e) {
    e.target.reset()
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
