import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["result", "loadingSpinner"]; // Add loadingSpinner target

  greet(event) {
    event.preventDefault(); // Prevent default form submission

    // Show the loading spinner
    this.loadingSpinnerTarget.classList.remove("d-none");

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
      // Use setTimeout to delay the update
      setTimeout(() => {
        // Hide the loading spinner
        this.loadingSpinnerTarget.style.display = "none";
        this.resultTarget.innerHTML = data;
      }, 2000); // 2000 milliseconds (2 seconds) delay, you can adjust this value
    })
    .catch(error => {
      // Hide the loading spinner on error
      this.loadingSpinnerTarget.style.display = "none";
      console.error('Error:', error);
    });
  }
}
