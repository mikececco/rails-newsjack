// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
document.addEventListener("click", function(e) {
  if (e.target && e.target.classList.contains("select-trend")) {
    const selectedTrend = e.target.getAttribute("data-trend");
    const isDisabled = e.target.getAttribute("data-disabled") === true;
    document.getElementById("selected-trend-field").value = selectedTrend;

    console.log(selectedTrend);

    // Check if there's another already selected button
    const selectedButton = document.querySelector(".select-trend[data-disabled='true']");

    if (selectedButton) {
      // Unselect the previously selected button
      selectedButton.removeAttribute("disabled");
      selectedButton.setAttribute("data-disabled", false);

      // Remove the 'selected-row' class from the corresponding row
      const selectedRow = selectedButton.closest("tr");
      selectedRow.classList.remove("selected-row");
    }

    if (!isDisabled) {
      // Select the new button
      e.target.setAttribute("disabled", true);
      e.target.setAttribute("data-disabled", true);

      // Remove the 'selected-row' class from all rows
      const rows = document.querySelectorAll("table tbody tr");
      rows.forEach(function(row) {
        row.classList.remove("selected-row");
      });

      // Add the 'selected-row' class to the clicked row
      const selectedRow = e.target.closest("tr");
      selectedRow.classList.add("selected-row");
    }
  }
});


const iconNavbarSidenav = document.getElementById('iconNavbarSidenav');
const iconSidenav = document.getElementById('iconSidenav');
const sidenav = document.getElementById('sidenav-main');
let body = document.getElementsByTagName('body')[0];
let className = 'g-sidenav-pinned';

if (iconNavbarSidenav) {
  iconNavbarSidenav.addEventListener("click", toggleSidenav);
}

if (iconSidenav) {
  iconSidenav.addEventListener("click", toggleSidenav);
}

function toggleSidenav() {
  if (body.classList.contains(className)) {
    body.classList.remove(className);
    setTimeout(function() {
      sidenav.classList.remove('bg-white');
    }, 100);
    sidenav.classList.remove('bg-transparent');

  } else {
    body.classList.add(className);
    sidenav.classList.add('bg-white');
    sidenav.classList.remove('bg-transparent');
    iconSidenav.classList.remove('d-none');
  }
}
