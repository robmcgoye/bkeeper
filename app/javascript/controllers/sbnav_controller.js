import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "btn" ]
  static values = { selected: { type: Number, default: 0 } }

  initialize() {
    this.dashboard();
  }

  dashboard() {
    this.set_page("BOOKEEPER: Dashboard", 0)
  }
  
  organization() {
    this.set_page("BOOKEEPER: Organizations", 1)
  }

  contribution() {
    this.set_page("BOOKEEPER: Contributions", 2)
  }

  accounting() {
    this.set_page("BOOKEEPER: Accounting", 3)
  }

  report() {
    this.set_page("BOOKEEPER: Reports", 4)
  }

  user() {
    this.set_page("BOOKEEPER: Users", 5)
  }

  selectedValueChanged() {
    this.setButtonState()
  }

  set_page(title, index) {
    this.selectedValue = index;
    document.title = title;
  }

  setButtonState() {
    this.btnTargets.forEach((element, index) => {
      if (index == this.selectedValue) {
        element.classList.add('active')
      } else {
        element.classList.remove('active')
      }
    })
  }

}
