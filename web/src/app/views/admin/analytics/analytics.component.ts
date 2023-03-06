import { Component, Input, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-analytics',
  templateUrl: './analytics.component.html',
  styleUrls: ['./analytics.component.css']
})
export class AnalyticsComponent implements OnInit {
  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== 'light' && color !== 'dark' ? 'light' : color;
  }
  private _color = 'light';
  public data : any = null;
  public startDate: any;
  public endDate : any;
  public type = "FORM";

  constructor(private commonService : CommonService) { }

  ngOnInit(): void {
  }

  getAnalytics(){
    this.commonService.getAnalytics({
      startDate  : this.startDate,
      endDate : this.endDate,
      type : this.type
    }).subscribe((data)=>{
      this.commonService.getExcelReport(data,this.startDate,this.endDate);
    })
  }

}
