import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
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
import { NgxUiLoaderModule } from "ngx-ui-loader";
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonService } from './services/common.service';
import { HttpClient, HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { ListComponent } from './views/admin/users/list/list.component';
import { UserInterceptor } from "./services/user.interceptor";
import { CreateComponent } from './views/admin/users/create/create.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { AngularMultiSelectModule } from 'angular2-multiselect-dropdown';
import { ServiceListComponent } from './views/admin/services/service-list/service-list.component';


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
    ServiceListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NgxUiLoaderModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    NgxPaginationModule,
    AngularMultiSelectModule
  ],
  providers: [UserInterceptor, { provide: HTTP_INTERCEPTORS, useClass: UserInterceptor, multi: true }, CommonService],
  bootstrap: [AppComponent]
})
export class AppModule { }
