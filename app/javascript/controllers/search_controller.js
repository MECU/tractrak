import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 400)
  }

  static targets = ['loading'];

  displayLoading(targets) {
    this.loadingTarget.classList.remove('visually-hidden');
  }

  displayContent(event) {
    this.loadingTarget.classList.add('visually-hidden');
  }
}
