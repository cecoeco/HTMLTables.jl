// Highlights rows on hover
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("table tbody tr").forEach((row) => {
    row.addEventListener("mouseenter", () => (row.style.backgroundColor = "#e0e0e0"));
    row.addEventListener("mouseleave", () => (row.style.backgroundColor = ""));
  });
});
