import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../services/common.service';

@Component({
  selector: 'app-feedbacks',
  templateUrl: './feedbacks.component.html',
  styleUrls: ['./feedbacks.component.css']
})
export class FeedbacksComponent implements OnInit {

  feedbackListData: any
  totalCount = 0
  page: number = 1


  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== "light" && color !== "dark" ? "light" : color;
  }
  private _color = "light";
  constructor(private commonService: CommonService) { }

  ngOnInit(): void {
    this.getAllFeedbacks()
  }

  getAllFeedbacks() {
    this.commonService.feedbackList(0, 10).subscribe(data => {
      this.feedbackListData = data.data
      this.totalCount = data.count
    })
  }

  onPageChange(evt: any) {
    this.page = evt
    this.commonService.usersList((this.page - 1) * 10, 10).subscribe(data => {

      this.feedbackListData = data.data
      this.totalCount = data.count

    })
  }

  generateInvoice() {
    // this.commonService.
  }

}
