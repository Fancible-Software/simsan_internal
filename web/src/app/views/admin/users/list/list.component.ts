import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service'
import { ToastrService } from 'ngx-toastr'

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css']
})
export class ListComponent implements OnInit {

  usersData: any
  totalUsers = 0
  page: number = 1

  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== "light" && color !== "dark" ? "light" : color;
  }
  private _color = "light";
  constructor(public commonService: CommonService, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.getAllUsers()
  }

  getAllUsers() {
    this.commonService.usersList(0, 10).subscribe(data => {
      if (data.status) {
        this.usersData = data.data.rows
        this.totalUsers = data.data.total
      }
      else {
        this.toastr.error(data.message)
      }
    })
  }

  onPageChange(evt: any) {
    this.page = evt
    this.commonService.usersList((this.page - 1) * 10, 10).subscribe(data => {
      if (data.status) {
        this.usersData = data.data.rows
        this.totalUsers = data.data.total
      }
      else {
        this.toastr.error(data.message)
      }
    })
  }

}
