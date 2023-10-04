import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  turbo_get(request){
    fetch(request, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  set_sort_icon(targets, sorts, selected) {
    let dir = 1;
    targets.forEach((element, index) => {
      if (index == selected) {
        if (sorts[selected] == 1) {
          element.classList.remove('bi-sort-alpha-down-alt'); 
          element.classList.add('bi-sort-alpha-down');
          dir = 2;
        } else {
          element.classList.remove('bi-sort-alpha-down');
          element.classList.add('bi-sort-alpha-down-alt'); 
        }
      } else {
        element.classList.remove('bi-sort-alpha-down');
        element.classList.remove('bi-sort-alpha-down-alt');  
      }
    });
    return dir;
  }  
}