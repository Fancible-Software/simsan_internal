import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpEventType, HttpRequest, HttpErrorResponse, HttpEvent } from '@angular/common/http';
import { environment } from '../../environments/environment.prod';
import { Observable, Subject, throwError } from 'rxjs';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class CommonService {

  constructor(private httpClient: HttpClient) { }

  // httpOptions = {
  //   headers: new HttpHeaders({
  //     'Authorization': 'Bearer ' + localStorage.getItem('token')
  //   })
  // }

  login(data: any): Observable<any> {
    return this.httpClient.post<any>(environment.endPoint + "/auth/login", data).pipe()
  }

  usersList(skip: number, limit: number): Observable<any> {
    return this.httpClient.get<any>(environment.endPoint + "/admin/users/" + skip + "/" + limit).pipe()
  }

  servicesList(skip: number, limit: number): Observable<any> {
    return this.httpClient.get<any>(environment.endPoint + "/services/all/" + skip + "/" + limit).pipe()
  }

  addService(body: any): Observable<any> {
    return this.httpClient.post<any>(environment.endPoint + "/services/create", body).pipe()
  }

}
