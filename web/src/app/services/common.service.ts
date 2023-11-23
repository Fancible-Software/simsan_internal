import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpHeaders,
  HttpEventType,
  HttpRequest,
  HttpErrorResponse,
  HttpEvent,
} from '@angular/common/http';
import { environment } from '../../environments/environment.prod';
import { Observable, Subject, throwError } from 'rxjs';
import { Router } from '@angular/router';
import { Workbook } from 'exceljs';
import * as fs from 'file-saver';

@Injectable({
  providedIn: 'root',
})
export class CommonService {
  constructor(private httpClient: HttpClient) {}

  // httpOptions = {
  //   headers: new HttpHeaders({
  //     'Authorization': 'Bearer ' + localStorage.getItem('token')
  //   })
  // }

  login(data: any): Observable<any> {
    return this.httpClient
      .post<any>(environment.endPoint + '/auth/login', data)
      .pipe();
  }

  usersList(skip: number, limit: number): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/admin/users/' + skip + '/' + limit)
      .pipe();
  }

  servicesList(skip: number, limit: number): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/services/all/' + skip + '/' + limit)
      .pipe();
  }

  addService(body: any): Observable<any> {
    return this.httpClient
      .post<any>(environment.endPoint + '/services/create', body)
      .pipe();
  }

  deleteService(id: number): Observable<any> {
    return this.httpClient
      .delete<any>(environment.endPoint + '/services/' + id)
      .pipe();
  }

  serviceDetail(id: number): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/services/service/' + id)
      .pipe();
  }

  updateService(body: any, serviceId: number): Observable<any> {
    return this.httpClient
      .put<any>(environment.endPoint + '/services/update/' + serviceId, body)
      .pipe();
  }

  activeServicesList(): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/services/all-services')
      .pipe();
  }

  provinceList(): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/location/provinces')
      .pipe();
  }

  citiesList(provinceId: string): Observable<any> {
    return this.httpClient
      .get<any>(
        environment.endPoint + '/location/cities?province_id=' + provinceId
      )
      .pipe();
  }

  submitFeedback(body: any): Observable<any> {
    return this.httpClient
      .post<any>(environment.endPoint + '/form/create', body)
      .pipe();
  }

  feedbackList(
    skip: number,
    limit: number,
    type: string,
    searchTerm?: string
  ): Observable<any> {
    return this.httpClient
      .get<any>(
        environment.endPoint +
          '/form/all/' +
          skip +
          '/' +
          limit +
          '?type=' +
          type +
          '&searchTerm=' +
          searchTerm
      )
      .pipe();
  }

  settingsList(skip: number, limit: number): Observable<any> {
    return this.httpClient
      .get<any>(
        environment.endPoint + '/configuration/all/' + skip + '/' + limit
      )
      .pipe();
  }

  createUser(body: any) {
    return this.httpClient
      .post<any>(environment.endPoint + '/admin/create/user', body)
      .pipe();
  }

  verifyUser(body: any) {
    return this.httpClient
      .post<any>(environment.endPoint + '/admin/verify/user', body)
      .pipe();
  }

  resendOtp(type: string) {
    return this.httpClient
      .get<any>(environment.endPoint + '/admin/resend/otp/' + type)
      .pipe();
  }

  headerCount() {
    return this.httpClient
      .get<any>(environment.endPoint + '/dashboard/count')
      .pipe();
  }

  getInvoiceDashboardGraph() {
    return this.httpClient
      .get<any>(environment.endPoint + '/dashboard/graph')
      .pipe();
  }

  generateInvoice(body: any) {
    return this.httpClient
      .post<any>('http://localhost:4100/invoice', body)
      .pipe();
  }

  markQuoteAsInvoice(formId: number, invoiceUuid: string) {
    return this.httpClient
      .get<any>(
        environment.endPoint +
          '/invoice/mark-as-invoice/' +
          formId +
          '/' +
          invoiceUuid
      )
      .pipe();
  }

  sendMail(value: string, body: undefined) {
    return this.httpClient
      .post<any>(environment.endPoint + '/email/' + value, body)
      .pipe();
  }

  fetchRole() {
    return this.httpClient
      .get<any>(environment.endPoint + '/admin/role')
      .pipe();
  }

  getFormDetailsById(id: number) {
    return this.httpClient
      .get<any>(environment.endPoint + '/form/' + id)
      .pipe();
  }

  updateForm(body: any, formId: number): Observable<any> {
    return this.httpClient
      .patch<any>(environment.endPoint + '/form/update/' + formId, body)
      .pipe();
  }

  getAnalytics(body: any): Observable<any> {
    return this.httpClient.post(`${environment.endPoint}/form/analytics`, body);
  }

  getExcelReport(analytics: any, from: string, to: string) {
    const workbook = new Workbook();
    const clientWorksheet = workbook.addWorksheet('Sales');
    const analyticsWorksheet = workbook.addWorksheet('Analytics');
    // if there is no data return
    if (analytics.data.length <= 0) {
      alert('No Records were found for the specified period !');
      return;
    }

    // add sales data to sales worksheet
    clientWorksheet.columns = Object.keys(analytics.data[0]).map(
      (column: any) => {
        return { header: column, key: column };
      }
    );
    clientWorksheet.autoFilter = 'A1:Z1';
    const newRows = clientWorksheet.addRows(
      Object.values(analytics.data).map((record: any) => Object.values(record))
    );

    // add analytics data to analytics worksheet
    let statistics = {
      ...analytics,
      data: null,
    };
    delete statistics['data'];
    analyticsWorksheet.columns = Object.keys(statistics).map((column: any) => {
      return { header: column, key: column };
    });
    const analyticsRows = analyticsWorksheet.addRow(Object.values(statistics));

    let startDate = new Date(from)
      .toLocaleString('en-us', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      })
      .replace(/(\d+)\/(\d+)\/(\d+)/, '$3-$1-$2');

    let endDate = new Date(to)
      .toLocaleString('en-us', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      })
      .replace(/(\d+)\/(\d+)\/(\d+)/, '$3-$1-$2');

    // save workbook
    workbook.xlsx.writeBuffer().then((data) => {
      let blob = new Blob([data], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });
      fs.saveAs(
        blob,
        'Report_Simsan_' + startDate + '_' + 'To_' + endDate + '_.xlsx'
      );
    });
  }

  updateUserStatus(id: number, status: number) {
    return this.httpClient.patch(
      `${environment.endPoint}/admin/update/status/${id}/${status}`,
      ''
    );
  }

  deleteUser(id: number) {
    return this.httpClient.delete(`${environment.endPoint}/admin/delete/${id}`);
  }

  addCompany(body: any): Observable<any> {
    return this.httpClient
      .post(`${environment.endPoint}/company/create`, body)
      .pipe();
  }
}
