import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-settings-create',
  templateUrl: './settings-create.component.html',
  styleUrls: ['./settings-create.component.css'],
})
export class SettingsCreateComponent implements OnInit {
  userType = 'sub_admin';
  constructor(
    private router: Router,
    private formBuilder: FormBuilder,
    public loader: NgxUiLoaderService,
    public service: CommonService,
    private route: ActivatedRoute,
    private toastr: ToastrService
  ) {
    this.service.fetchRole().subscribe((data) => {
      this.userType = data.role;
      if (this.userType == 'sub_admin') {
        this.toastr.error('You are not authorized to view this page');
        this.router.navigate(['/admin/quotes', { type: 'QUOTE' }]);
        return;
      }
    });
  }

  serviceForm: FormGroup | any;
  submitted = false;
  serviceId: number = 0;

  ngOnInit(): void {
    this.serviceForm = this.formBuilder.group({
      key: ['', [Validators.required]],
      value: ['', [Validators.required, Validators.pattern('^[1-9][0-9]*$')]],
      isImage: ['', [Validators.required]],
    });
    if (this.route.snapshot.params['id']) {
      this.serviceId = this.route.snapshot.params['id'];
    }
  }

  get f() {
    return this.serviceForm.controls;
  }

  cancel() {
    this.router.navigate(['/admin/services']);
  }

  update() {}
}
