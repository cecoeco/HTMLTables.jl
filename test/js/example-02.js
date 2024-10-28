// Alerts the cell content when clicked
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("table td").forEach((cell) => {
    cell.addEventListener("click", () => alert(`Cell value: ${cell.textContent.trim()}`));
  });
});
