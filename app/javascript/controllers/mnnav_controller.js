import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "sbnav" ]

  edit_password() {
    this.set_page("BOOKEEPER: Change password");
  }

  edit_email() {
    this.set_page("BOOKEEPER: Change email");
  }

  view_sessions() {
    this.set_page("BOOKEEPER: Sessions");
  }

  set_page(title) {
    document.title = title;
    this.sbnavOutlet.selectedValue = -1;
  }
}
