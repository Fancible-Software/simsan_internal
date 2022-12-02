import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
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
  serviceId: number = 0
  constructor(private router: Router, private formBuilder: FormBuilder, public loader: NgxUiLoaderService, public service: CommonService, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.serviceForm = this.formBuilder.group({
      serviceName: ['', [Validators.required]],
      price: ['', [Validators.required, Validators.pattern('^[1-9][0-9]*$')]],
      isActive: ['', [Validators.required]]
    })
    if (this.route.snapshot.params['id']) {
      this.serviceId = this.route.snapshot.params['id']
      this.service.serviceDetail(this.serviceId).subscribe((serviceDetail: any) => {
        this.serviceForm.patchValue({
          serviceName: serviceDetail.data.serviceName,
          isActive: serviceDetail.data.isActive,
          price: serviceDetail.data.price
        })
      })
    }
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

  update() {
    this.submitted = true
    this.loader.start()
    if (this.serviceForm.status == "INVALID") {
      this.loader.stop()
      return
    }
    let body = {
      serviceName: this.serviceForm.value.serviceName,
      isActive: this.serviceForm.value.isActive.toString(),
      price: this.serviceForm.value.price
    }

    this.service.updateService(body, this.serviceId).subscribe(data => {
      if (data.status) {
        alert(data.message)
        this.router.navigateByUrl('/admin/services')
      }
    })

  }

}
