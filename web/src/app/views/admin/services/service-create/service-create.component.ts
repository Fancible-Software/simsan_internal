import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-service-create',
  templateUrl: './service-create.component.html',
  styleUrls: ['./service-create.component.css'],
})
export class ServiceCreateComponent implements OnInit {
  serviceForm: FormGroup | any;
  submitted = false;
  serviceId: number = 0;
  userType = 'sub_admin';

  constructor(
    private router: Router,
    private formBuilder: FormBuilder,
    public loader: NgxUiLoaderService,
    public service: CommonService,
    private route: ActivatedRoute
  ) {
    this.service.fetchRole().subscribe((data) => {
      this.userType = data.role;
    });
  }

  ngOnInit(): void {
    this.serviceForm = this.formBuilder.group({
      serviceName: ['', [Validators.required]],
      price: ['', [Validators.required, Validators.pattern('^[1-9][0-9]*$')]],
      isActive: ['', [Validators.required]],
      priority: [0],
    });
    if (this.route.snapshot.params['id']) {
      this.serviceId = this.route.snapshot.params['id'];
      this.service
        .serviceDetail(this.serviceId)
        .subscribe((serviceDetail: any) => {
          this.serviceForm.patchValue({
            serviceName: serviceDetail.data.serviceName,
            isActive: serviceDetail.data.isActive,
            price: serviceDetail.data.price,
            priority: serviceDetail.data.priority,
          });
        });
    }
  }

  cancel() {
    this.router.navigate(['/admin/services']);
  }

  get f() {
    return this.serviceForm.controls;
  }

  submit() {
    // console.log(this.serviceForm.status)
    this.submitted = true;
    this.loader.start();
    if (this.serviceForm.status == 'INVALID') {
      this.loader.stop();
      return;
    }
    this.service
      .addService({
        ...this.serviceForm.value,
        isActive: parseInt(this.serviceForm.controls['isActive'].value),
      })
      .subscribe((data) => {
        this.loader.stop();
        alert(data.message);
        this.router.navigate(['/admin/services']);
      });
  }

  update() {
    this.submitted = true;
    this.loader.start();
    if (this.serviceForm.status == 'INVALID') {
      this.loader.stop();
      return;
    }

    this.service
      .updateService(
        {
          ...this.serviceForm.value,
          isActive: parseInt(this.serviceForm.controls['isActive'].value),
        },
        this.serviceId
      )
      .subscribe((data) => {
        // alert(data.message)
        if (data.status) {
          alert(data.message);
          this.router.navigateByUrl('/admin/services');
        }
      });
  }
}
