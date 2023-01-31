import { Component, OnInit, Input } from '@angular/core';
import { environment } from '../../../../environments/environment.prod';
import { CommonService } from '../../../services/common.service';
import { ActivatedRoute, Router } from '@angular/router';
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
  userType = 'sub_admin';

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
    private toastr: ToastrService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.type = this.route.snapshot.params['type'];
    this.commonService.fetchRole().subscribe((data) => {
      this.userType = data.role;

      if (this.type === 'FORM' && this.userType === 'sub_admin') {
        this.toastr.error('You are not authorized to view this page');
        this.router.navigate(['/admin/quotes', { type: 'QUOTE' }]);
        return;
      } else {
        this.getAllFeedbacks();
      }
    });
  }

  getAllFeedbacks() {
    this.commonService.feedbackList(0, 10, this.type, '').subscribe((data) => {
      this.feedbackListData = data.data;
      this.totalCount = data.count.count;
    });
  }

  onPageChange(evt: any) {
    this.page = evt;
    this.commonService
      .feedbackList((this.page - 1) * 10, 10, this.type, '')
      .subscribe((data) => {
        this.feedbackListData = data.data;
        this.totalCount = data.count.count;
      });
  }

  getInvoiceUrl(feedBack: any) {
    let path = this.type === 'FORM' ? 'invoice' : 'quote';
    return `${environment.endPoint}/${path}/${feedBack.formId}/${feedBack.invoiceUuid}`;
  }

  search() {
    if (this.searchTerm === '') return;

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
