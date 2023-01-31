import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { environment } from 'src/environments/environment.prod';
import { Router } from '@angular/router';
@Component({
  selector: 'app-email',
  templateUrl: './email.component.html',
  styleUrls: ['./email.component.css'],
})
export class EmailComponent implements OnInit {
  items: { id: number; name: string; value: string }[] = [
    { id: 1, name: 'Canada Day', value: 'canadaDay' },
    { id: 2, name: 'Christmas', value: 'christmas' },
    { id: 3, name: 'Thanks Giving', value: 'thanksgiving' },
    { id: 4, name: 'Summer', value: 'summer' },
    { id: 5, name: 'Winter', value: 'winter' },
    { id: 6, name: 'Generic', value: 'generic' },
  ];
  userType = 'sub_admin';
  constructor(
    private commonService: CommonService,
    private toastr: ToastrService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.commonService.fetchRole().subscribe((data) => {
      this.userType = data.role;
      if (this.userType == 'sub_admin') {
        this.toastr.error('You are not authorized to view this page');
        this.router.navigate(['/admin/quotes', { type: 'QUOTE' }]);
        return;
      }
    });
  }

  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== 'light' && color !== 'dark' ? 'light' : color;
  }
  private _color = 'light';

  sendMail(value: string) {
    if (
      confirm(
        'This will trigger an email to be sent to all users. Are you sure you want to continue?'
      )
    ) {
      this.commonService.sendMail(value, undefined).subscribe((data) => {
        if (data.status) {
          this.toastr.success(data.message);
        } else {
          this.toastr.error(data.message);
        }
      });
    }
  }

  viewTemplate(value: string) {
    // console.log(`${environment.endPoint}/email/view/${value}`)
    return `${environment.endPoint}/email/view/${value}`;
  }
}
