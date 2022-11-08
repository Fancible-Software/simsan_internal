import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service'
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { ToastrService } from 'ngx-toastr'

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
  constructor(public commonService: CommonService, private loader: NgxUiLoaderService, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.getAllServices()
  }

  getAllServices() {
    this.loader.start()
    this.commonService.servicesList(this.page - 1, 10).subscribe(data => {
      // console.log(data)
      if (data.status) {
        this.toastr.success(data.message)
        this.servicesData = data.data.rows
        this.totalServices = data.data.total
      }
      else {
        this.toastr.error(data.message)
      }
      this.loader.stop()
    })
  }

  onPageChange(evt: any) {
    this.page = evt
    this.commonService.servicesList((this.page - 1) * 10, 10).subscribe(data => {
      if (data.status) {
        this.servicesData = data.data.rows
        this.totalServices = data.data.total
      }
      else {
        this.toastr.error(data.message)
      }
    })
  }

}
