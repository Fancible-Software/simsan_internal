import { Component, OnInit } from '@angular/core';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { CommonService } from '../../../../services/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-verification',
  templateUrl: './verification.component.html',
  styleUrls: ['./verification.component.css'],
})
export class VerificationComponent implements OnInit {
  verifyForm: FormGroup | any;
  submitted = false;

  constructor(
    private router: Router,
    private activateRoute: ActivatedRoute,
    private formBuilder: FormBuilder,
    private commonService: CommonService,
    private toastr: ToastrService
  ) {}

  ngOnInit(): void {
    this.verifyForm = this.formBuilder.group({
      otp: ['', [Validators.required]],
      type: ['', [Validators.required]],
    });
    this.verifyForm.patchValue({
      type: this.activateRoute.snapshot.paramMap.get('type'),
    });
  }

  verify() {
    this.submitted = true;
    if (this.verifyForm.status === 'INVALID') {
      console.log(this.verifyForm.status);
      console.log(this.verifyForm);
      return;
    }
    this.commonService.verifyUser(this.verifyForm.value).subscribe((data) => {
      if (data.status) {
        this.toastr.success(data.message, 'SUCCESS');
        localStorage.setItem('is_verified', 'true');
        this.router.navigate(['/admin/dashboard']);
        return;
      } else {
        this.toastr.error(data.message, 'ERROR');
      }
    });
  }

  get f() {
    return this.verifyForm.controls;
  }

  resendOtp() {
    this.commonService
      .resendOtp(this.verifyForm.value.type)
      .subscribe((data) => {
        if (data.status) {
          this.toastr.success(data.message, 'SUCCESS');
        }
      });
  }

  logout() {
    localStorage.clear();
    this.router.navigate(['/']);
  }
}
