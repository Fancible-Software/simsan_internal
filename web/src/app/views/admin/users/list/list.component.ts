import { Component, OnInit } from '@angular/core';
import { CommonService } from '../../../../services/common.service'
@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css']
})
export class ListComponent implements OnInit {

  constructor(public commonService: CommonService) { }

  ngOnInit(): void {
    // this.getAllUsers()

  }

  getAllUsers() {
    this.commonService.usersList(0, 10).subscribe(data => {
      console.log(data)
    })
  }

}
