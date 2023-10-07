import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="osearch"
export default class extends Controller {
  static values = { create: { type: Boolean, default: false }};
  static outlets = [ "sortmgmt" ]

  connect() {
    if (this.createValue == true) {
      this.sortmgmtOutlet.filter();
    } else {
      this.sortmgmtOutlet.update_query();
    }      
  }
}
