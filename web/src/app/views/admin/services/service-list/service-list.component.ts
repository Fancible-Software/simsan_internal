import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service'

@Component({
  selector: 'app-service-list',
  templateUrl: './service-list.component.html',
  styleUrls: ['./service-list.component.css']
})
export class ServiceListComponent implements OnInit {

  servicesData: any = []
  totalServices: number = 0
  page: number = 1

  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== "light" && color !== "dark" ? "light" : color;
  }
  private _color = "light";
  constructor(public commonService: CommonService) { }

  ngOnInit(): void {
    this.getAllServices()
  }

  getAllServices() {
    this.commonService.servicesList(this.page - 1, 10).subscribe(data => {
      // console.log(data)
      if (data.status) {
        this.servicesData = data.data.rows
        this.totalServices = data.data.total
      }
      else {

      }
    })
  }

  onPageChange(evt: any) {
    this.page = evt
    console.log(evt)
    this.commonService.servicesList((this.page - 1) * 10, 10).subscribe(data => {
      if (data.status) {
        this.servicesData = data.data.rows
        this.totalServices = data.data.total
      }
    })
  }

}
