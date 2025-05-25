import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("Search controller connected");
    this.timeout = null;
  }

  disconnect() {
    // Clean up timeout when controller disconnects
    if (this.timeout) {
      clearTimeout(this.timeout);
    }
  }

  search() {
    console.log("Search triggered with value:", this.inputTarget.value);
    
    // Clear the previous timeout
    clearTimeout(this.timeout);
    
    // Set a new timeout - only search after user stops typing for 500ms
    this.timeout = setTimeout(() => {
      console.log("Actually submitting search for:", this.inputTarget.value);
      this.element.requestSubmit();
    }, 500); // 500ms delay - adjust this as needed
  }
}