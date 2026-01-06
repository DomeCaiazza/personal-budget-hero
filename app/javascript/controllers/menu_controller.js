import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay"]

  connect() {
    // Close menu when clicking outside on mobile
    document.addEventListener("click", this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this))
  }

  toggle() {
    if (this.menuTarget.classList.contains("-translate-x-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("-translate-x-full")
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("hidden")
    }
  }

  close() {
    this.menuTarget.classList.add("-translate-x-full")
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add("hidden")
    }
  }

  handleClickOutside(event) {
    // Only handle on mobile (when overlay is visible)
    if (window.innerWidth >= 1024) return
    
    if (this.hasMenuTarget && !this.menuTarget.contains(event.target) && 
        !event.target.closest('[data-action*="menu#toggle"]')) {
      this.close()
    }
  }
}

