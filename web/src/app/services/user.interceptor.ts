import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, of, throwError } from 'rxjs';
import { catchError, tap, retry } from 'rxjs/operators';
import { Router } from '@angular/router';


@Injectable()
export class UserInterceptor implements HttpInterceptor {

  constructor(private router: Router) { }

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    console.log(this.router.url)
    if (this.router.url == "/auth/login") {
      return next.handle(request);
    }
    if (localStorage.getItem('token') !== null) {
      request = request.clone({ headers: request.headers.set('Authorization', 'Bearer ' + localStorage.getItem('token')) });
    }
    return next.handle(request).pipe(
      retry(2),
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401) {

          localStorage.removeItem('token')
          this.router.navigateByUrl('/login');
        }
        return throwError(error);
      })
    )
  }
}
