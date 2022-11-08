import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './guard/auth.guard';
import { AdminComponent } from './layouts/admin/admin.component';
import { AuthComponent } from './layouts/auth/auth.component';
import { DashboardComponent } from './views/admin/dashboard/dashboard.component';
import { FeedbacksComponent } from './views/admin/feedbacks/feedbacks.component';
import { CreateComponent } from './views/admin/users/create/create.component';
import { ListComponent } from './views/admin/users/list/list.component';
import { LoginComponent } from './views/auth/login/login.component';
import { IndexComponent } from './views/index/index.component';
import { ServiceListComponent } from './views/admin/services/service-list/service-list.component'

const routes: Routes = [
  { path: "", component: IndexComponent },
  {
    path: "auth",
    component: AuthComponent,
    children: [
      { path: "login", component: LoginComponent },
      { path: "", redirectTo: "login", pathMatch: "full" }
    ]
  },
  {
    path: "admin",
    component: AdminComponent,
    canActivate: [AuthGuard],
    children: [
      { path: "dashboard", component: DashboardComponent },
      { path: "feedbacks", component: FeedbacksComponent },
      { path: "users", component: ListComponent },
      { path: "users/create", component: CreateComponent },
      { path: "services", component: ServiceListComponent }
    ]
  }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
