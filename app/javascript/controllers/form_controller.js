// app/javascript/controllers/form_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form", "popup"];

  submitForm(event) {
    event.preventDefault();
    const form = this.formTarget;
    const popup = this.popupTarget;

    fetch(form.action, {
      method: form.method,
      body: new FormData(form)
    })
    .then(response => response.json())
    .then(data => {
      // Set the message in the popup and display it
      popup.textContent = data.message;
      popup.classList.add("active"); // Add a CSS class to show the popup
    })
    .catch(error => {
      console.error("Error:", error);
    });
  }
}
