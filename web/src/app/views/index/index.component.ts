import { Component, OnInit } from '@angular/core';
import { CommonService } from '../../services/common.service';
import { FormBuilder, FormGroup, FormArray, FormControl, ValidatorFn, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr'
import { Router } from '@angular/router';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css']
})
export class IndexComponent implements OnInit {

  enabled = false
  form: FormGroup;
  submitted = false
  services: any = []
  provinces: any = []
  cities: any = []
  constructor(private commonService: CommonService, private formBuilder: FormBuilder, private toastr: ToastrService, private router: Router) {
    this.form = this.formBuilder.group({
      name: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      mobile_no: ['', [Validators.required]],
      address: ['', Validators.required],
      city: ['', Validators.required],
      province: ['', Validators.required],
      postal_code: ['', Validators.required],
      services_dropdown: new FormArray([]),
      services: [[], Validators.required],
      total_amount: ['', [Validators.required]],
      discount: [''],
      final_amount: ['', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.getActiveServicesList()
    this.getProvinceList()
  }

  get servicesFormArray() {
    return this.form.controls['services_dropdown'] as FormArray;
  }

  getActiveServicesList() {
    this.commonService.activeServicesList().subscribe(data => {
      if (data.status) {
        this.services = data.data.rows
        this.addCheckboxesToForm();
      }
    })
  }

  private addCheckboxesToForm() {
    this.services.forEach(() => this.servicesFormArray.push(new FormControl(false)));
  }

  generateAmount() {
    const selectedOrderIds: any = []
    let amount: number = 0
    // console.log(this.form.value.services_dropdown)
    this.form.value.services_dropdown.map((checked: any, i: number) => {
      if (checked) {
        selectedOrderIds.push({ "serviceId": this.services[i].serviceId, "price": this.services[i].price })
        amount = amount + (+this.services[i].price)
      }
    }).filter((v: number) => v !== null);
    if (!selectedOrderIds.length) {
      alert('Please select any of the above service!')
      return
    }
    this.form.patchValue({
      "total_amount": amount,
      "final_amount": amount + ((amount * 5) / 100),
      "services": selectedOrderIds
    })
    this.enabled = true


  }

  finalSubmit() {

    this.submitted = true
    if (this.form.status == "INVALID") {
      return
    }
    let formData = {
      "customerName": this.form.value.name,
      "customerEmail": this.form.value.email,
      "customerAddress": this.form.value.address,
      "customerCity": this.form.value.city,
      "customerCountry": "Canada",
      "customerPostalCode": this.form.value.postal_code,
      "customerPhone": this.form.value.mobile_no,
      "customerProvince": this.form.value.province,
      "discount": this.form.value.discount.toString(),
      "total": this.form.value.total_amount.toString(),
      "final_amount": this.form.value.final_amount.toString(),
      "services": this.form.value.services
    }
    this.commonService.submitFeedback(formData).subscribe(data => {
      this.toastr.success(data.message, "SUCCESS")
      this.router.navigateByUrl('admin/feedbacks')
    })
  }

  get f() { return this.form.controls; }

  applyDiscount(evt: any) {
    const discPerc = evt.target.value
    let discountedAmount = this.form.value.total_amount - (this.form.value.total_amount * (discPerc / 100))
    this.form.patchValue({
      "final_amount": (discountedAmount + (discountedAmount * 5) / 100).toFixed(2)
    })
  }

  clear() {
    this.form.controls['services_dropdown'].reset()
    this.enabled = false
    this.form.controls['total_amount'].reset()
    this.form.controls['final_amount'].reset()
    this.form.controls['discount'].reset()
  }

  getProvinceList() {
    this.commonService.provinceList().subscribe(data => {
      this.provinces = data.data
    })
  }

  onChange(evt: any) {

    let provinceId = evt.target.value
    if (provinceId) {
      this.commonService.citiesList(provinceId).subscribe(data => {
        this.cities = data.data
      })
    }
  }

}
