import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CardBarChartComponent } from './card-bar-chart.component';

describe('CardBarChartComponent', () => {
  let component: CardBarChartComponent;
  let fixture: ComponentFixture<CardBarChartComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CardBarChartComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CardBarChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
