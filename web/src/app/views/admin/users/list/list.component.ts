import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service'
@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css']
})
export class ListComponent implements OnInit {

  usersData: any
  totalUsers = 0

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
    this.getAllUsers()

  }

  getAllUsers() {
    this.commonService.usersList(0, 10).subscribe(data => {
      console.log(data)
      if (data.status) {
        this.usersData = data.data.rows
        this.totalUsers = data.data.total
      }
      else {

      }
    })
  }

}
