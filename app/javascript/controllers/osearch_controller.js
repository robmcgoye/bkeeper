import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="osearch"
export default class extends Controller {
  static values = { create: { type: Boolean, default: false }};
  static outlets = [ "organization" ]

  connect() {
    if (this.createValue == true) {
      this.organizationOutlet.filter();
    } else {
      this.organizationOutlet.update_query();
    }      
  }
}
