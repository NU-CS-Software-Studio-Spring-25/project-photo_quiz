import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    // Optionally, focus input on connect
    // this.inputTarget.focus();
  }

  search() {
    this.element.requestSubmit(); // submits the form wrapping this controller element
  }
}