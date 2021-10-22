import { Component } from '@angular/core';
import { Usuario } from '../models/Usuario';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent {
  constructor() {
    let test = 2;
    const lest2 = 2;
    var test2 = 3;
  }


  func1() {
    let arr = ["a", "b", "c"];

    let expectedValue = "b";
    if (expectedValue in arr) { // Noncompliant, will be always false
        return expectedValue + " found in the array";
    } else {
        return expectedValue + " not found";
    }
}

 func2() {
    let arr = ["a", "b", "c"];

    let expectedValue = "1"; // index #1 is corresponding to the value "b"
    if (expectedValue in arr) { // Noncompliant, will be always true because the array is made of 3 elements and the #1 is always there whatever its value
        return expectedValue + " found in the array";
    } else {
        return expectedValue + " not found";
    }
}


  deleteFuunction() {
    var myArray = ['a', 'b', 'c', 'd'];

    delete myArray[2];  // Noncompliant. myArray => ['a', 'b', undefined, 'd']
    console.log(myArray[2]); // expected value was 'd' but output is undefined
  }



  test() {
    let target = -5;
    let num = 3;

    target = - num;  // Noncompliant; target = -3. Is that really what's meant?
    target = + num; // Noncompliant; target = 3
  }



}
