import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../services/common.service';
import { ToastrService } from 'ngx-toastr';
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

  constructor(
    private commonService: CommonService,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {}

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
}
