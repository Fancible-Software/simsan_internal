import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-service-create',
  templateUrl: './service-create.component.html',
  styleUrls: ['./service-create.component.css']
})
export class ServiceCreateComponent implements OnInit {

  serviceForm: FormGroup | any
  submitted = false
  constructor(private router: Router, private formBuilder: FormBuilder, public loader: NgxUiLoaderService, public service: CommonService) { }

  ngOnInit(): void {
    this.serviceForm = this.formBuilder.group({
      serviceName: ['', [Validators.required, Validators.pattern('^[a-zA-Z0-9]*[a-zA-Z]+[a-zA-Z0-9]*$')]],
      price: ['', [Validators.required, Validators.pattern('^[1-9][0-9]*$')]],
      isActive: ['', [Validators.required]]
    })
  }

  cancel() {
    this.router.navigate(['/admin/services'])
  }

  get f() { return this.serviceForm.controls; }


  submit() {
    // console.log(this.serviceForm.status)
    this.submitted = true
    this.loader.start()
    if (this.serviceForm.status == "INVALID") {
      this.loader.stop()
      return
    }
    this.service.addService(this.serviceForm.value).subscribe(data => {

      this.loader.stop()
      alert(data.message)
      this.router.navigate(['/admin/services'])

    })

  }

}
