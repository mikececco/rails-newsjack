import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["result"];

  greet(event) {
    event.preventDefault(); // Prevent default form submission

    const form = event.currentTarget.closest("form");
    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'text/html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.text())
    .then(data => {
      // Update a specific element with the response
      this.resultTarget.innerHTML = data;
    })
    .catch(error => console.error('Error:', error));
  }
}
