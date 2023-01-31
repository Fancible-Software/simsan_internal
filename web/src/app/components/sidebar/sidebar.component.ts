import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonService } from '../../services/common.service';
@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
})
export class SidebarComponent implements OnInit {
  collapseShow = 'hidden';
  userType = 'sub_admin';

  constructor(public router: Router, private commonService: CommonService) {}

  ngOnInit() {
    this.commonService.fetchRole().subscribe((data) => {
      
      this.userType = data.role;
    });
  }
  toggleCollapseShow(classes: any) {
    this.collapseShow = classes;
  }

  onLogout() {
    localStorage.removeItem('token');
    localStorage.removeItem('is_verified');
    // localStorage.removeItem('user_type');
    this.router.navigate(['/auth/login']);
  }
}
