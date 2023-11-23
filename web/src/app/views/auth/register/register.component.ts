import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonService } from '../../../services/common.service';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-register',
  // standalone: true,
  styleUrls: ['./register.component.css'],
  templateUrl: './register.component.html',
})
export class RegisterComponent {
  registerationForm: FormGroup | any;
  submitted = false;

  constructor(
    public router: Router,
    private formBuilder: FormBuilder,
    public loader: NgxUiLoaderService,
    private service: CommonService,
    private toastr: ToastrService
  ) {}

  ngOnInit() {
    this.registerationForm = this.formBuilder.group(
      {
        companyName: [
          '',
          Validators.compose([
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(30),
          ]),
        ],
        governmentBusinessId: ['', Validators.compose([Validators.required])],
        governmentBusinessProof: [
          'https://test.blob.com/',
          Validators.required,
        ],
        firstName: ['', Validators.compose([Validators.required])],
        lastName: ['', Validators.compose([Validators.required])],
        email: ['', Validators.compose([Validators.required])],
        mobileNo: ['', Validators.compose([Validators.required])],
        password: [
          '',
          Validators.compose([
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(30),
          ]),
        ],
        confPassword: [
          '',
          Validators.compose([
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(30),
          ]),
        ],
      },
      { validator: this.passwordMatchValidator }
    );
  }

  passwordMatchValidator(control: FormGroup): { mismatch: boolean } {
    const password = control.get('password');
    const confirmPassword = control.get('confPassword');

    if (
      password &&
      confirmPassword &&
      password.value !== confirmPassword.value
    ) {
      return { mismatch: true };
    }

    return { mismatch: false };
  }

  onSubmit() {
    this.submitted = true;
    console.log(this.registerationForm.value);
    if (this.registerationForm.status !== 'INVALID') {
      return;
    }
    this.loader.start();
    this.service.addCompany(this.registerationForm.value).subscribe((data) => {
      console.log(data);
      this.loader.stop();
    });
  }

  get f() {
    return this.registerationForm.controls;
  }

  onFilechange(event: any) {
    console.log(event.target.files[0]);
    // this.file = event.target.files[0];
  }
}
