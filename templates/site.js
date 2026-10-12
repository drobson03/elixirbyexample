// Left/right arrow keys move between examples, like Go by Example.
document.addEventListener("keydown", (e) => {
  if (e.altKey || e.ctrlKey || e.metaKey || e.shiftKey) return;
  if (e.key === "ArrowLeft" && PREV) window.location.href = PREV;
  if (e.key === "ArrowRight" && NEXT) window.location.href = NEXT;
});

const copyButton = document.querySelector("button.copy");
if (copyButton && SOURCE) {
  copyButton.addEventListener("click", async () => {
    await navigator.clipboard.writeText(SOURCE);
    copyButton.textContent = "copied!";
    setTimeout(() => (copyButton.textContent = "copy"), 1500);
  });
}
