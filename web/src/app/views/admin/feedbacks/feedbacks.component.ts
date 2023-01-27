import { Component, OnInit, Input } from '@angular/core';
import { environment } from '../../../../environments/environment.prod';
import { CommonService } from '../../../services/common.service';
import { ActivatedRoute } from '@angular/router';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-feedbacks',
  templateUrl: './feedbacks.component.html',
  styleUrls: ['./feedbacks.component.css'],
})
export class FeedbacksComponent implements OnInit {
  feedbackListData: any;
  totalCount = 0;
  page: number = 1;
  type = 'FORM';
  searchTerm: string = '';

  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== 'light' && color !== 'dark' ? 'light' : color;
  }
  private _color = 'light';

  constructor(
    private commonService: CommonService,
    private route: ActivatedRoute,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {
    this.type = this.route.snapshot.params['type'];
    // console.log(this.totalCount);

    this.getAllFeedbacks();
  }

  getAllFeedbacks() {
    this.commonService.feedbackList(0, 10, this.type, '').subscribe((data) => {
      // console.log(data)
      this.feedbackListData = data.data;
      this.totalCount = data.count.count;
      // console.log(this.totalCount);
    });

  }

  onPageChange(evt: any) {
    this.page = evt;
    this.commonService
      .feedbackList((this.page - 1) * 10, 10, this.type, '')
      .subscribe((data) => {
        this.feedbackListData = data.data;
        this.totalCount = data.count.count
      });
  }

  getInvoiceUrl(feedBack: any) {
    let path = this.type === 'FORM' ? 'invoice' : 'quote';
    return `${environment.endPoint}/${path}/${feedBack.formId}/${feedBack.invoiceUuid}`;
  }

  search() {
    if (this.searchTerm === '') return;
    // console.log(this.searchTerm);
    this.commonService
      .feedbackList(0, 10, this.type, this.searchTerm)
      .subscribe((data) => {
        this.feedbackListData = data.data;
        this.totalCount = data.count.count;
      });
  }

  clear() {
    this.searchTerm = '';
    this.ngOnInit();
  }

  markQuoteAsInvoice(formId: number, invoiceUuid: string) {
    if (confirm('Are you sure you want to mark this quote as invoice?')) {
      this.commonService
        .markQuoteAsInvoice(formId, invoiceUuid)
        .subscribe((data) => {
          this.toastr.success('Marked as Invoice');
          this.ngOnInit();
        });
    }
  }
}
