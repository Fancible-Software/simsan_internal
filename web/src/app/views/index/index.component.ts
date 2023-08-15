import { Component, OnInit } from '@angular/core';
import { CommonService } from '../../services/common.service';
import {
  FormBuilder,
  FormGroup,
  FormArray,
  FormControl,
  ValidatorFn,
  Validators,
} from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { Router, ActivatedRoute } from '@angular/router';
import { NgxUiLoaderService } from 'ngx-ui-loader';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css'],
})
export class IndexComponent implements OnInit {
  enabled = false;
  form: FormGroup;
  submitted = false;
  services: any = [];
  editableServices: any = [];
  provinces: any = [];
  cities: any = [];
  formType: string = 'FORM';
  selectedCity: string = '';
  isFormSubmitted: boolean = false;
  selectedServices: any = [];
  discountPercentage: any = 0;
  formId: number = 0;
  invoiceUuid: string = '';
  isFormUpdated: string = 'CREATE';
  formData: any;
  userType = 'sub_admin';

  constructor(
    private commonService: CommonService,
    private formBuilder: FormBuilder,
    private toastr: ToastrService,
    private router: Router,
    private loader: NgxUiLoaderService,
    private route: ActivatedRoute
  ) {
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
      discount_percent: [''],
      amount_after_discount: [''],
      discount: [''],
      final_amount: ['', [Validators.required]],
      tax_applicable: [false],
      comment: [''],
    });
  }

  ngOnInit(): void {
    // console.log(this.route.snapshot.params['formId']);
    this.commonService.fetchRole().subscribe((data) => {
      this.userType = data.role;
    });
    this.getProvinceList();
    if (this.route.snapshot.params['formId']) {
      this.isFormUpdated = 'UPDATE';
      this.formId = this.route.snapshot.params['formId'];

      this.commonService
        .getFormDetailsById(+this.route.snapshot.params['formId'])
        .subscribe((data) => {
          // Mark services as selected that were previously attached
          this.selectedServices = data['data']['formToServices'].map(
            (record: any) => {
              return {
                ...record['service'],
                price: record['price'],
              };
            }
          );
          // get service ids of previously attached services
          const serviceIds = this.selectedServices.map(
            (row: any) => row['serviceId']
          );
          // fetch all services & merge with previously selected services price so that we can get overriden price
          this.commonService.activeServicesList().subscribe((obj) => {
            if (obj.status) {
              const fetchedRows = obj.data.rows.filter(
                (row: any) => !serviceIds.includes(row['serviceId'])
              );
              this.services = [...fetchedRows, ...this.selectedServices];
              this.editableServices = [
                ...fetchedRows,
                ...this.selectedServices,
              ];
            }
          });

          // create service data for form
          const selectedOrderIds: any = [];
          let amount: number = 0;

          this.selectedServices
            .map((service: any) => {
              if (service) {
                selectedOrderIds.push({
                  serviceId: service.serviceId,
                  price: parseInt(service.price),
                });
                amount = amount + parseInt(service.price);
              }
            })
            .filter((v: number) => v !== null);

          this.formData = data.data;
          this.invoiceUuid = data.data.invoiceUuid;
          // console.log(data);
          // update form
          this.form.patchValue({
            name: data.data.customerName,
            email: data.data.customerEmail,
            mobile_no: data.data.customerPhone,
            address: data.data.customerAddress,
            city: data.data.customerCity,
            province: data.data.customerProvince,
            postal_code: data.data.customerPostalCode,
            total_amount: data.data.total,
            discount_percent: data.data.discount_percent,
            amount_after_discount: data.data.final_amount,
            discount: data.data.discount,
            final_amount: data.data.final_amount,
            tax_applicable: data.data.is_taxable,
            comment: data.data.comment,
            services: selectedOrderIds,
          });
          var event = {
            target: {
              value: data.data.customerProvince,
            },
          };
          this.onChange(event);
        });
    } else {
      this.getActiveServicesList();
    }

    if (this.route.snapshot.params['type'] === 'FORM') {
      this.formType = this.route.snapshot.params['type'];
    } else if (this.route.snapshot.params['type'] === 'QUOTE') {
      this.formType = this.route.snapshot.params['type'];
    } else {
      this.toastr.warning('Invalid URL', 'WARNING');
      this.router.navigateByUrl('admin/services');
    }

    this.form.controls['total_amount'].valueChanges.subscribe((val: any) => {
      this.updateValues(val);
    });
  }

  get servicesFormArray() {
    return this.form.controls['services_dropdown'] as FormArray;
  }

  getActiveServicesList() {
    this.commonService.activeServicesList().subscribe((data) => {
      if (data.status) {
        this.services = [...data.data.rows];
        this.editableServices = [...data.data.rows];
        // this.addCheckboxesToForm();
      }
    });
  }

  generateAmount() {
    const selectedOrderIds: any = [];
    let amount: number = 0;

    this.selectedServices
      .map((service: any) => {
        if (service) {
          selectedOrderIds.push({
            serviceId: service.serviceId,
            price: parseInt(service.price),
          });
          amount = amount + parseInt(service.price);
        }
      })
      .filter((v: number) => v !== null);

    this.form.patchValue({
      total_amount: amount,
      services: selectedOrderIds,
    });

    this.enabled = true;
  }

  finalSubmit() {
    this.loader.start();
    this.submitted = true;
    this.isFormSubmitted = true;
    if (this.form.status == 'INVALID' || this.selectedServices.length === 0) {
      if (this.selectedServices.length === 0) {
        alert('Please select any of the above service!');
      }
      this.loader.stop();
      this.isFormSubmitted = false;
      return;
    }
    let formData = {
      customerName: this.form.value.name,
      customerEmail: this.form.value.email,
      customerAddress: this.form.value.address,
      customerCity: this.form.value.city,
      customerCountry: 'Canada',
      customerPostalCode: this.form.value.postal_code,
      customerPhone: this.form.value.mobile_no,
      customerProvince: this.form.value.province,
      discount: this.form.value.discount.toString(),
      total: this.form.value.total_amount.toString(),
      final_amount: this.form.value.final_amount.toString(),
      services: this.form.value.services,
      is_taxable: this.form.value.tax_applicable,
      discount_percent: this.form.value.discount_percent.toString(),
      type: this.formType,
      comment: this.form.value.comment,
    };

    if (this.isFormUpdated === 'UPDATE') {
      this.commonService.updateForm(formData, this.formId).subscribe((data) => {
        this.loader.stop();
        this.toastr.success(data.message, 'SUCCESS');
        if (this.formType === 'QUOTE') {
          this.router.navigate(['admin/feedbacks', { type: 'QUOTE' }]);
        } else {
          this.router.navigate(['admin/feedbacks', { type: 'FORM' }]);
        }
      });
    } else {
      this.commonService.submitFeedback(formData).subscribe((data) => {
        this.loader.stop();
        this.toastr.success(data.message, 'SUCCESS');
        if (this.formType === 'QUOTE') {
          this.router.navigate(['admin/feedbacks', { type: 'QUOTE' }]);
        } else {
          this.router.navigate(['admin/feedbacks', { type: 'FORM' }]);
        }
      });
    }
  }

  get f() {
    return this.form.controls;
  }

  applyDiscount(evt: any) {
    const discPerc = evt.target.value;
    this.discountPercentage = discPerc;
    const discountAmount = this.form.value.total_amount * (discPerc / 100);
    // this.form.value.discount = discountAmount
    let discountedAmount =
      this.form.value.total_amount -
      this.form.value.total_amount * (discPerc / 100);

    if (this.form.value.tax_applicable) {
      this.form.patchValue({
        final_amount: (discountedAmount + (discountedAmount * 5) / 100).toFixed(
          2
        ),
        discount: discountAmount,
        amount_after_discount: discountedAmount,
        discount_percent: discPerc,
      });
    } else {
      this.form.patchValue({
        discount: discountAmount,
        amount_after_discount: discountedAmount,
        final_amount: discountedAmount,
        discount_percent: discPerc,
      });
    }
  }

  /***
   * function that handles any change event to absolute discount inputS
   * @param event {Event} input change event 
   * @returns null
   */
  applyAbsoluteDiscount(event : Event){
    let discount = parseInt((event.target as HTMLInputElement).value);
    let discountPercentage =
      (discount / this.form.value.total_amount ) * 100;

    let discountAmount = this.form.value.total_amount - discount;

    // If discount is greater than total_amount as for confirmation
    if(discount > this.form.value.total_amount 
      && !window.confirm("Discount is bigger than total price, do you want to proceed ?") 
      ) discount = 0;

    // If tax is applicable then we add tax on top 
    if (this.form.value.tax_applicable) {
      this.form.patchValue({
        final_amount: (discountAmount + (discountAmount * 5) / 100).toFixed(
          2
        ),
        discount: discount,
        amount_after_discount: discountAmount,
        discount_percent: discountPercentage,
      });
    } else { // Do not add taxa simply propagate changes
      this.form.patchValue({
        discount: discount,
        amount_after_discount: discountAmount,
        final_amount: discountAmount,
        discount_percent: discountPercentage,
      });
    }

  }

  clear() {
    this.form.controls['services_dropdown'].reset();
    this.enabled = false;
    this.form.controls['total_amount'].reset();
    this.form.controls['final_amount'].reset();
    this.form.controls['discount'].reset();
    this.form.controls['discount_percent'].reset();
  }

  getProvinceList() {
    this.commonService.provinceList().subscribe((data) => {
      this.provinces = data.data;
    });
  }

  onChange(evt: any) {
    let provinceId = evt.target.value;
    // console.log(provinceId);
    if (provinceId) {
      this.commonService.citiesList(provinceId).subscribe((data) => {
        this.cities = data.data;
      });
    }
  }

  isTaxApplicable() {
    const discPerc = this.form.value.discount_percent;
    let discountedAmount =
      this.form.value.total_amount -
      this.form.value.total_amount * (discPerc / 100);

    if (this.form.value.tax_applicable) {
      this.form.patchValue({
        final_amount: (discountedAmount + (discountedAmount * 5) / 100).toFixed(
          2
        ),
      });
    } else {
      this.form.patchValue({
        final_amount: discountedAmount,
      });
    }
  }

  updateValues(totalAmount: any) {
    totalAmount = parseInt(totalAmount);
    const discPerc = this.discountPercentage;

    let discountAmount = totalAmount * (discPerc / 100);
    let discountedAmount = totalAmount - totalAmount * (discPerc / 100);

    if (this.form.value.tax_applicable) {
      this.form.patchValue({
        final_amount: (discountedAmount + (discountedAmount * 5) / 100).toFixed(
          2
        ),
        discount: discountAmount,
        amount_after_discount: discountedAmount,
        discount_percent: this.discountPercentage,
      });
    } else {
      this.form.patchValue({
        final_amount: discountedAmount,
        discount: discountAmount,
        amount_after_discount: discountedAmount,
        discount_percent: this.discountPercentage,
      });
    }
  }

  markQuoteAsInvoice(formId: number, invoiceUuid: string) {
    this.loader.start();
    if (confirm('Are you sure you want to mark this quote as invoice?')) {
      this.commonService
        .markQuoteAsInvoice(formId, invoiceUuid)
        .subscribe((data) => {
          this.loader.stop();
          this.toastr.success('Marked as Invoice');
          this.router.navigate(['/admin/feedbacks', { type: 'FORM' }]);
        });
    }
  }

  changeTextToUppercase() {
    this.form.patchValue({
      postal_code: this.form.value.postal_code.toUpperCase(),
    });
    // var obj = {};
    // obj[field] = this.form.controls[field].value.toUpperCase();
    // this.form.patchValue(obj);
  }
}
