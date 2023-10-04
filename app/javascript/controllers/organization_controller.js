import AppController from "./app_controller";

// Connects to data-controller="organization"
export default class extends AppController {
  static targets = [ "sort_icon", "query" ];
  static values = { selected: { type: Number, default: 0 }, 
                    query: { type: String, default: ""},
                    dir: { type: Number, default: 1},
                    url: String 
                  };
  // enum = [ "name" = 0, "contact" = 1, "type" = 2];
  orders = [ 1, 1, 1 ];
  query = "";

  initialize() {
    for (let index = 0; index < this.orders.length; index++) {
      if (index == this.selectedValue) {
        this.orders[index] = this.dirValue;
      }
    };
    this.queryTarget.value = this.queryValue;
    this.query = this.queryTarget.value;
  }
  
  update_query(){
    this.queryTarget.value = this.query;
  }

  filter() {
    this.query = this.queryTarget.value;
    this.orders[0] = 1;
    this.orders[0] = super.set_sort_icon(this.sort_iconTargets, this.orders, 0);
  }

  get_current_sort_dir(){
    if (this.orders[this.selectedValue] == 1) {
      return 2;
    } else {
      return 1;
    }
  }

  show(e){
    const url = `${e.srcElement.getAttribute("data-url")}&by=${this.selectedValue}&dir=${this.get_current_sort_dir()}&query=${this.queryTarget.value}`;
    super.turbo_get(url);
    e.preventDefault();
  }

  name_sort(e) {
    this.urlValue = e.srcElement.getAttribute("data-url");
    this.set_selected(0);
    e.preventDefault();
  }

  contact_sort(e) {
    this.urlValue = e.srcElement.getAttribute("data-url");
    this.set_selected(1);
    e.preventDefault();
  }

  type_sort(e) {
    this.urlValue = e.srcElement.getAttribute("data-url");
    this.set_selected(2);
    e.preventDefault();
  }
  
  set_selected(value) {
    if (this.selectedValue != value) {
      this.selectedValue = value;
      this.reset_sort_dir(value);
    } else {
      this.selectedValueChanged();
    }
  }

  selectedValueChanged() {
    this.query = this.queryTarget.value;
    const url = `${this.urlValue}&dir=${this.orders[this.selectedValue]}&query=${this.queryTarget.value}`;
    super.turbo_get(url);
    this.orders[this.selectedValue] = super.set_sort_icon(this.sort_iconTargets, this.orders, this.selectedValue);  
  }

  reset_sort_dir(current_index) {
    for (let index = 0; index < this.orders.length; index++) {
      if (index != current_index) {
        this.orders[index] = 1;
      }
    }
  }

}
