import { Component, OnInit } from '@angular/core';
import { CommonService } from '../../../services/common.service'

@Component({
  selector: 'app-header-stats',
  templateUrl: './header-stats.component.html',
  styleUrls: ['./header-stats.component.css']
})
export class HeaderStatsComponent implements OnInit {

  stats: any
  constructor(private commonService: CommonService) { }

  ngOnInit(): void {
    this.getDashboardCount()
  }

  getDashboardCount() {
    this.commonService.headerCount().subscribe(data => {
      if (data.status) {
        this.stats = data.data
      }
    })
  }

}
