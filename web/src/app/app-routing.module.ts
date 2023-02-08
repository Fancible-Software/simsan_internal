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
import { ServiceListComponent } from './views/admin/services/service-list/service-list.component';
import { ServiceCreateComponent } from './views/admin/services/service-create/service-create.component';
import { SettingsListComponent } from './views/admin/settings/settings-list/settings-list.component';
import { SettingsCreateComponent } from './views/admin/settings/settings-create/settings-create.component';
import { VerificationComponent } from './views/auth/verify/verification/verification.component';
import { EmailComponent } from './views/admin/email/email.component';

const routes: Routes = [
  { path: '', redirectTo: 'auth', pathMatch: 'full' },
  {
    path: 'auth',
    component: AuthComponent,
    children: [
      { path: 'login', component: LoginComponent },
      { path: '', redirectTo: 'login', pathMatch: 'full' },
      { path: 'verify/user/:type', component: VerificationComponent },
    ],
  },
  {
    path: 'collect/feedback',
    component: IndexComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'admin',
    component: AdminComponent,
    canActivate: [AuthGuard],
    children: [
      { path: 'dashboard', component: DashboardComponent },
      { path: 'feedbacks', component: FeedbacksComponent },
      { path: 'quotes', component: FeedbacksComponent },
      { path: 'users', component: ListComponent },
      { path: 'users/create', component: CreateComponent },
      { path: 'services', component: ServiceListComponent },
      { path: 'services/create', component: ServiceCreateComponent },
      { path: 'services/edit/:id', component: ServiceCreateComponent },
      { path: 'configurations', component: SettingsListComponent },
      { path: 'configurations/create', component: SettingsCreateComponent },
      { path: 'configurations/edit/:id', component: SettingsCreateComponent },
      { path: 'mails', component: EmailComponent },

      // { path: "verify/user", component: VerificationComponent }
    ],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
