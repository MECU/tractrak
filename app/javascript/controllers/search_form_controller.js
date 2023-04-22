import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 400)
  }

  static targets = ['loading'];

  displayLoading(event) {
    this.loadingTarget.classList.remove('hidden');
  }

  displayContent() {
    this.loadingTarget.classList.add('hidden');
  }
}
