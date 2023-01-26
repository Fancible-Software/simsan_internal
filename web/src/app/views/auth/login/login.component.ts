import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonService } from '../../../services/common.service';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup | any;

  constructor(
    public router: Router,
    private formBuilder: FormBuilder,
    public loader: NgxUiLoaderService,
    private service: CommonService,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {
    if (localStorage.getItem('token')) {
      this.router.navigate(['/admin/feedbacks', { type: 'FORM' }]);
    }
    this.loginForm = this.formBuilder.group({
      email: ['', [Validators.required]],
      password: ['', [Validators.required]],
    });
  }

  login() {
    this.loader.start();
    if (this.loginForm.status == 'INVALID') {
      // this.toastr.warning('All fields are mandatory', 'Warning')
      this.loader.stop();
      return;
    }
    this.service.login(this.loginForm.value).subscribe((data) => {
      if (data.status) {
        this.loader.stop();
        this.toastr.success(data.message, 'SUCCESS');
        localStorage.setItem('token', data.data.token);
        localStorage.setItem('is_verified', data.data.is_verified);

        if (data.data.is_verified) {
          this.router.navigate(['/admin/feedbacks', { type: 'FORM' }]);
        } else {
          this.router.navigate(['/auth/verify/user', 'otp']);
        }
      } else {
        this.toastr.error(data.message);
        this.loader.stop();
      }
    });
  }
}
