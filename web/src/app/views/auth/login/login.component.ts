import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonService } from '../../../services/common.service'
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  loginForm: FormGroup | any

  constructor(public router: Router, private formBuilder: FormBuilder, public loader: NgxUiLoaderService, private service: CommonService) { }

  ngOnInit(): void {
    if (localStorage.getItem('token')) {
      this.router.navigate(['/admin/dashboard'])
    }
    this.loginForm = this.formBuilder.group({
      email: ['', [Validators.required]],
      password: ['', [Validators.required]]
    })
  }

  login() {
    this.loader.start()
    if (this.loginForm.status == "INVALID") {
      // this.toastr.warning('All fields are mandatory', 'Warning')
      this.loader.stop()
      return
    }
    this.service.login(this.loginForm.value).subscribe(data => {
      if (data.status) {
        this.loader.stop()
        localStorage.setItem("token", data.data.token)
        this.router.navigate(['/admin/dashboard'])
      }
      else {
        alert('Login failed!')
        this.loader.stop()
      }
    })

  }

}
