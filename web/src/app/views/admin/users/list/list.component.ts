import { Component, OnInit, Input } from '@angular/core';
import { CommonService } from '../../../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css'],
})
export class ListComponent implements OnInit {
  usersData: any;
  totalUsers = 0;
  page: number = 1;
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
    public commonService: CommonService,
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
      this.getAllUsers();
    });
  }

  getAllUsers() {
    this.commonService.usersList(0, 10).subscribe((data) => {
      if (data.status) {
        this.usersData = data.data.rows;
        this.totalUsers = data.data.total;
      } else {
        this.toastr.error(data.message);
      }
    });
  }

  onPageChange(evt: any) {
    this.page = evt;
    this.commonService.usersList((this.page - 1) * 10, 10).subscribe((data) => {
      if (data.status) {
        this.usersData = data.data.rows;
        this.totalUsers = data.data.total;
      } else {
        this.toastr.error(data.message);
      }
    });
  }

  updateStatus(id: number, status: number) {
    // console.log(id, status);
    if (confirm('This will activate/deactivate the user. are you sure you want proceed with this?')) {
      if (status == 1) {
        status = 0;
      } else {
        status = 1;
      }
      this.commonService.updateUserStatus(id, status).subscribe((data: any) => {
        if (data.status) {
          this.toastr.success(data.message);
          this.getAllUsers();
        } else {
          this.toastr.error(data.message);
        }
      });
    }
  }

  deleteUser(id: number) {
    if (confirm('are you sure, you want to delete?')) {
      this.commonService.deleteUser(id).subscribe((data: any) => {
        if (data.status) {
          this.toastr.success(data.message);
          this.ngOnInit();
        } else {
          this.toastr.error(data.message);
        }
      });
    }
  }
}
