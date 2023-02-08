import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { TableModule } from 'primeng/table';
import { AppComponent } from './app.component';
import { LoginComponent } from './views/auth/login/login.component';
import { IndexComponent } from './views/index/index.component';
import { DashboardComponent } from './views/admin/dashboard/dashboard.component';
import { AdminComponent } from './layouts/admin/admin.component';
import { AuthComponent } from './layouts/auth/auth.component';
import { IndexNavbarComponent } from './components/navbars/index-navbar/index-navbar.component';
import { FooterComponent } from './components/footers/footer/footer.component';
import { IndexDropdownComponent } from './components/dropdowns/index-dropdown/index-dropdown.component';
import { AuthNavbarComponent } from './components/navbars/auth-navbar/auth-navbar.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { AdminNavbarComponent } from './components/navbars/admin-navbar/admin-navbar.component';
import { FooterAdminComponent } from './components/footers/footer-admin/footer-admin.component';
import { HeaderStatsComponent } from './components/headers/header-stats/header-stats.component';
import { CardStatsComponent } from './components/cards/card-stats/card-stats.component';
import { CardSocialTrafficComponent } from './components/cards/card-social-traffic/card-social-traffic.component';
import { CardPageVisitsComponent } from './components/cards/card-page-visits/card-page-visits.component';
import { CardBarChartComponent } from './components/cards/card-bar-chart/card-bar-chart.component';
import { CardLineChartComponent } from './components/cards/card-line-chart/card-line-chart.component';
import { FeedbacksComponent } from './views/admin/feedbacks/feedbacks.component';
import { CardTableComponent } from './components/cards/card-table/card-table.component';
import { TableDropdownComponent } from './components/dropdowns/table-dropdown/table-dropdown.component';
import { NgxUiLoaderModule } from 'ngx-ui-loader';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonService } from './services/common.service';
import {
  HttpClient,
  HttpClientModule,
  HTTP_INTERCEPTORS,
} from '@angular/common/http';
import { ListComponent } from './views/admin/users/list/list.component';
import { UserInterceptor } from './services/user.interceptor';
import { CreateComponent } from './views/admin/users/create/create.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { AngularMultiSelectModule } from 'angular2-multiselect-dropdown';
import { ServiceListComponent } from './views/admin/services/service-list/service-list.component';
import { ToastrModule } from 'ngx-toastr';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ServiceCreateComponent } from './views/admin/services/service-create/service-create.component';
import { SettingsListComponent } from './views/admin/settings/settings-list/settings-list.component';
import { SettingsCreateComponent } from './views/admin/settings/settings-create/settings-create.component';
import { VerificationComponent } from './views/auth/verify/verification/verification.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { EmailComponent } from './views/admin/email/email.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    IndexComponent,
    DashboardComponent,
    AdminComponent,
    AuthComponent,
    IndexNavbarComponent,
    FooterComponent,
    IndexDropdownComponent,
    AuthNavbarComponent,
    SidebarComponent,
    AdminNavbarComponent,
    FooterAdminComponent,
    HeaderStatsComponent,
    CardStatsComponent,
    CardSocialTrafficComponent,
    CardPageVisitsComponent,
    CardBarChartComponent,
    CardLineChartComponent,
    FeedbacksComponent,
    CardTableComponent,
    TableDropdownComponent,
    ListComponent,
    CreateComponent,
    ServiceListComponent,
    ServiceCreateComponent,
    SettingsListComponent,
    SettingsCreateComponent,
    VerificationComponent,
    EmailComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    NgxUiLoaderModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    NgxPaginationModule,
    AngularMultiSelectModule,
    TableModule,
    ToastrModule.forRoot({
      timeOut: 10000,
      positionClass: 'toast-top-right',
      preventDuplicates: true,
    }),
    NgSelectModule,
  ],
  providers: [
    UserInterceptor,
    { provide: HTTP_INTERCEPTORS, useClass: UserInterceptor, multi: true },
    CommonService,
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
