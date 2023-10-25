window.addEventListener("scroll", function() {
  // Get the component and trigger div elements
  var component = document.querySelector("#tag");
  var triggerDiv = document.getElementById("statement");
  console.log("HELLOOO");

  // Get the position of the trigger div relative to the viewport
  var triggerDivPosition = triggerDiv.getBoundingClientRect();

  // Check if the trigger div is in the viewport
  if (triggerDivPosition.bottom <= window.innerHeight) {
      component.style.display = "none"; // Hide the component
  } else {
      component.style.display = "block"; // Show the component
  }
});
