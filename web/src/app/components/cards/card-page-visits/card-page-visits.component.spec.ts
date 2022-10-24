import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CardPageVisitsComponent } from './card-page-visits.component';

describe('CardPageVisitsComponent', () => {
  let component: CardPageVisitsComponent;
  let fixture: ComponentFixture<CardPageVisitsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CardPageVisitsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CardPageVisitsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
