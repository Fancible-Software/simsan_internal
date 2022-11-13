import { Component, OnInit } from '@angular/core';
import { CommonService } from '../../services/common.service';
import { FormBuilder, FormGroup, FormArray, FormControl, ValidatorFn, Validators } from '@angular/forms';


@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css']
})
export class IndexComponent implements OnInit {

  form: FormGroup;
  submitted = false
  services: any = []
  constructor(private commonService: CommonService, private formBuilder: FormBuilder) {
    this.form = this.formBuilder.group({
      name: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      mobile_no: ['', [Validators.required]],
      address: ['', Validators.required],
      city: ['', Validators.required],
      province: ['', Validators.required],
      postal_code: ['', Validators.required],
      services: new FormArray([]),
      total_amount: ['', [Validators.required]],
      discount: [''],
      final_amount: ['', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.getActiveServicesList()
  }

  get servicesFormArray() {
    return this.form.controls['services'] as FormArray;
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
    this.form.value.services.map((checked: any, i: number) => {
      if (checked) {
        selectedOrderIds.push(this.services[i].serviceId)
        amount = amount + (+this.services[i].price)
      }
    }).filter((v: number) => v !== null);

    this.form.patchValue({
      "total_amount": amount,
      "final_amount": amount + ((amount * 5) / 100),
      "services": selectedOrderIds
    })

  }

  finalSubmit() {
    this.submitted = true
    if (this.form.status == "INVALID") {
      return
    }
    console.log(this.form.value)
  }

  get f() { return this.form.controls; }


}
