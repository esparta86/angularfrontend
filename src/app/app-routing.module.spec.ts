import {
  ComponentFixture,
  fakeAsync,
  TestBed,
  tick,
} from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent } from './app.component';
//importing routes
import { routes } from './app-routing.module';
import { Router } from '@angular/router';
import { Location } from '@angular/common';

describe('AppRoutingModule', () => {
  let router: Router;
  let fixture: ComponentFixture<AppComponent>;
  let location: Location;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RouterTestingModule.withRoutes(routes)],
      declarations: [AppComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    router = TestBed.inject(Router);
    location = TestBed.inject(Location);
    fixture = TestBed.createComponent(AppComponent);
    router.initialNavigation();
  });

  it('should test redirection to default path', () => {
    fixture.detectChanges();
    fixture.whenStable().then(() => {
      expect(location.path()).toBe('/');
    });
  });

  it('should test redirection to /user path', fakeAsync(() => {
    fixture.detectChanges();
    tick();
    router.navigate(['user']);
    tick();
    expect(location.path()).toBe('/user');
  }));
});
