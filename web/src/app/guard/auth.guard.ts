import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router, CanActivate, RouterStateSnapshot, UrlTree } from '@angular/router';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private router: Router) { }

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    if (localStorage.getItem('token')) {
      // console.log(localStorage.getItem('is_verified'))
      if (localStorage.getItem('is_verified') === "false") {
        this.router.navigate(["auth/verify/user/otp"])
        return false
      }
      else{
        return true
      }
      
    } else {
      this.router.navigate(["auth/login"]);
      return false
    }
  }

}
