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

  feedbackList(skip: number, limit: number, type: string,searchTerm?: string): Observable<any> {
    return this.httpClient
      .get<any>(environment.endPoint + '/form/all/' + skip + '/' + limit + '?type=' + type+'&searchTerm='+searchTerm)
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
}
