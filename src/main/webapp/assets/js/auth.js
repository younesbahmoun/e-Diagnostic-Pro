"use strict";

// Forms still submit to the existing Java servlets without JavaScript.
document.querySelectorAll("[data-password-toggle]").forEach((button) => {
    const input = document.getElementById(button.getAttribute("aria-controls"));
    if (!input) return;
    button.hidden = false;
    button.addEventListener("click", () => {
        const visible = input.type === "password";
        input.type = visible ? "text" : "password";
        button.setAttribute("aria-pressed", String(visible));
        button.setAttribute("aria-label", visible ? "Masquer le mot de passe" : "Afficher le mot de passe");
    });
});

const roleInputs = document.querySelectorAll('input[name="role"]');
const specialistFields = document.querySelector("[data-specialist-fields]");
function updateSpecialistFields() {
    if (!specialistFields) return;
    const selectedRole = document.querySelector('input[name="role"]:checked');
    const isSpecialist = selectedRole?.value === "SPECIALISTE";
    specialistFields.hidden = !isSpecialist;
    specialistFields.disabled = !isSpecialist;
}
roleInputs.forEach((input) => input.addEventListener("change", updateSpecialistFields));
updateSpecialistFields();

document.querySelectorAll("[data-auth-form]").forEach((form) => {
    const button = form.querySelector('button[type="submit"]');
    const label = button?.querySelector("[data-submit-label]");
    if (!button || !label) return;
    const originalLabel = label.textContent;
    form.addEventListener("submit", (event) => {
        if (event.defaultPrevented) return;
        button.disabled = true;
        button.classList.add("is-loading");
        form.setAttribute("aria-busy", "true");
        label.textContent = button.dataset.loadingLabel;
    });
    // Restore controls when returning to a cached form with the Back button.
    window.addEventListener("pageshow", () => {
        button.disabled = false;
        button.classList.remove("is-loading");
        form.removeAttribute("aria-busy");
        label.textContent = originalLabel;
        updateSpecialistFields();
    });
});
document.querySelector("[data-auth-feedback]")?.focus();
