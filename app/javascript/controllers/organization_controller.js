import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="organization"
export default class extends Controller {
  static targets = [ "sort_icon", "query" ];
  // enum = [ "name" = 0, "contact" = 1, "type" = 2];
  order = [ 1, 1, 1 ];

  initialize() {
    this.set_sort_icon(0);
  }
 
  filter() {
    this.order[0] = 1;
    this.set_sort_icon(0);
  }

  name_sort(e) {
    // console.log(this.queryTarget.value);
    const url = e.srcElement.getAttribute("data-url");
    this.get_list(`${url}&dir=${this.order[0]}&query=${this.queryTarget.value}`);
    this.set_sort_icon(0);
    e.preventDefault();
  }

  contact_sort(e) {
    const url = e.srcElement.getAttribute("data-url");
    this.get_list(`${url}&dir=${this.order[1]}&query=${this.queryTarget.value}`);
    this.set_sort_icon(1);
    e.preventDefault();
  }

  type_sort(e) {
    const url = e.srcElement.getAttribute("data-url");
    this.get_list(`${url}&dir=${this.order[2]}&query=${this.queryTarget.value}`);
    this.set_sort_icon(2);
    e.preventDefault();
  }

  get_list(request){
    fetch(request, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  set_sort_icon(selected){
    this.sort_iconTargets.forEach((element, index) => {
      if (index == selected) {
        if (this.order[selected] == 1) {
          element.classList.remove('bi-sort-alpha-down-alt'); 
          element.classList.add('bi-sort-alpha-down');
          this.order[selected] = 2;
        } else {
          element.classList.remove('bi-sort-alpha-down');
          element.classList.add('bi-sort-alpha-down-alt'); 
          this.order[selected] = 1;
        }
      } else {
        element.classList.remove('bi-sort-alpha-down');
        element.classList.remove('bi-sort-alpha-down-alt');  
      }
    });
  }

}
