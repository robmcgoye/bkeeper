import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reports"
export default class extends Controller {
  connect() {
  }

  print_commitment(e) {
    e.preventDefault();
    let commitment_form = document.getElementById("commitment_report");
    let commitment_report = window.open("", 'commitment_report', 'popup=yes,height=600,width=800');
 
    if (commitment_report) {
      commitment_form.target = "commitment_report";
      commitment_form.submit();
    } else {
       alert('You must allow popups to print reports.');
    }    
  }
}
