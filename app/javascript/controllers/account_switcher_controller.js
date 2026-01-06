import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    accountId: String,
    forceChoice: { type: Boolean, default: false }
  }
  static targets = ["modal", "overlay"]

  handleClick(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Se è forzata la scelta manuale, mostra sempre il modal
    if (this.forceChoiceValue) {
      this.openModal()
      return
    }

    // Prova a determinare automaticamente la versione in base alla larghezza dello schermo
    const version = this.detectVersion()
    
    if (version) {
      // Versione determinata automaticamente, procedi direttamente
      this.switchAccount(version)
    } else {
      // Non è riuscito a determinare, mostra il modal per la scelta manuale
      this.openModal()
    }
  }

  detectVersion() {
    try {
      const width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
      
      // Breakpoint Tailwind lg: 1024px
      // >= 1024px = desktop → Console
      // < 1024px = mobile/tablet → Webapp
      if (width >= 1024) {
        return "console"
      } else if (width < 1024 && width > 0) {
        return "webapp"
      }
      
      // Se la larghezza non è valida o è 0, non determinare automaticamente
      return null
    } catch (error) {
      // In caso di errore, non determinare automaticamente
      console.warn("Impossibile rilevare la larghezza dello schermo:", error)
      return null
    }
  }

  openModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove("hidden")
      if (this.hasOverlayTarget) {
        this.overlayTarget.classList.remove("hidden")
      }
    }
  }

  closeModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
      if (this.hasOverlayTarget) {
        this.overlayTarget.classList.add("hidden")
      }
    }
  }

  selectVersion(event) {
    const version = event.currentTarget.dataset.version
    this.closeModal()
    this.switchAccount(version)
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  switchAccount(version) {
    const form = document.createElement("form")
    form.method = "POST"
    form.action = `/accounts/${this.accountIdValue}/switch`
    
    // Aggiungi il token CSRF
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (csrfToken) {
      const csrfInput = document.createElement("input")
      csrfInput.type = "hidden"
      csrfInput.name = "authenticity_token"
      csrfInput.value = csrfToken
      form.appendChild(csrfInput)
    }

    // Aggiungi il parametro version
    const versionInput = document.createElement("input")
    versionInput.type = "hidden"
    versionInput.name = "version"
    versionInput.value = version
    form.appendChild(versionInput)

    // Aggiungi il metodo POST
    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "post"
    form.appendChild(methodInput)

    document.body.appendChild(form)
    form.submit()
  }
}

