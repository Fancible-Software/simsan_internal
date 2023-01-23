import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { Router } from '@angular/router';

@Component({
  selector: 'app-settings-list',
  templateUrl: './settings-list.component.html',
  styleUrls: ['./settings-list.component.css'],
})
export class SettingsListComponent implements OnInit {
  settingsList: any = [];
  count: number = 0;
  page: number = 1;

  @Input()
  get color(): string {
    return this._color;
  }
  set color(color: string) {
    this._color = color !== 'light' && color !== 'dark' ? 'light' : color;
  }
  private _color = 'light';

  constructor(
    private service: CommonService,
    private loader: NgxUiLoaderService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.getServicesList();
  }

  getServicesList() {
    this.loader.start();
    this.service.settingsList(this.page - 1, 10).subscribe((data) => {
      if (data.status) {
        this.settingsList = data.data;
        this.count = data.count;
      }
    });
  }

  editSetting(configId: number) {
    this.router.navigateByUrl(`/admin/configurations/edit/${configId}`);
  }
}
