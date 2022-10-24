import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CardSocialTrafficComponent } from './card-social-traffic.component';

describe('CardSocialTrafficComponent', () => {
  let component: CardSocialTrafficComponent;
  let fixture: ComponentFixture<CardSocialTrafficComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CardSocialTrafficComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CardSocialTrafficComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
