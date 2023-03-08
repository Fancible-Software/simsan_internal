import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { CommonService } from '../../../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { NgxUiLoaderService } from 'ngx-ui-loader';

@Component({
  selector: 'app-create',
  templateUrl: './create.component.html',
  styleUrls: ['./create.component.css'],
})
export class CreateComponent implements OnInit {
  userForm: FormGroup | any;
  submitted = false;
  userType = 'sub_admin';

  constructor(
    private router: Router,
    private formBuilder: FormBuilder,
    private commonService: CommonService,
    private toastr: ToastrService,
    private loader: NgxUiLoaderService
  ) {
    this.commonService.fetchRole().subscribe((data) => {
      this.userType = data.role;
      if (this.userType == 'sub_admin') {
        this.toastr.error('You are not authorized to view this page');
        this.router.navigate(['/admin/quotes', { type: 'QUOTE' }]);
        return;
      }
    });
  }

  ngOnInit(): void {
    this.userForm = this.formBuilder.group({
      first_name: ['', [Validators.required]],
      last_name: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
      mobile_no: [
        '',
        [
          Validators.required,
          Validators.pattern(
            '^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'
          ),
        ],
      ],
      roles: ['', [Validators.required]],
    });
  }

  submit() {
    this.loader.start();
    this.submitted = true;
    if (this.userForm.status == 'INVALID') {
      this.loader.stop();
      this.toastr.warning('Invalid form request!', 'WARNING');
      return;
    }
    this.commonService.createUser(this.userForm.value).subscribe((data) => {
      if (data.status) {
        this.toastr.success(data.message, 'SUCCESS');
        this.router.navigateByUrl('/admin/users');
      }
      this.loader.stop();
    });
  }

  get f() {
    return this.userForm.controls;
  }

  cancel() {
    this.router.navigateByUrl('/admin/users');
  }
}
