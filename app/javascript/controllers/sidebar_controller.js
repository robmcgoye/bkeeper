import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // console.log("Yo... hello!")
  }

  toggle() {
    // console.log("hello!")
    const side_bar = document.getElementById("sidebar");
    side_bar.classList.toggle('active');
    const org_sub_menu = document.getElementById("orgsubmenu");
    org_sub_menu.classList.toggle('dropdown-toggle');
    
    
 }
}
