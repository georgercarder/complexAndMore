//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SignedSafeMath.sol";

// note on safemath vs solidity v8.. when this contract was written there was not 
//   good support in tooling for the underlying errors from solc v8 safemath,
//   so used safemath lib to have explicit overflow errors.

import "hardhat/console.sol";

library ComplexAndMore {
    using SignedSafeMath for int256;
    using ComplexAndMore for Complex;
    using ComplexAndMore for Quaternion;
    using ComplexAndMore for Octonion;
    using ComplexAndMore for Sedenion;
    
    int256 constant private COEF = -1;

    struct Complex {
        int256 Re;
        int256 Im;
    }

    function newComplex(int256 re, int256 im) internal returns(Complex memory) {
        return Complex({Re: re, Im: im}); 
    }

    function add(Complex memory a, Complex memory b) internal returns(Complex memory) {
        return newComplex(a.Re.add(b.Re), a.Im.add(b.Im));
    }

    function sub(Complex memory a, Complex memory b) internal returns(Complex memory) {
        return newComplex(a.Re.sub(b.Re), a.Im.sub(b.Im));
    }

    function mul(Complex memory a, Complex memory b) internal returns(Complex memory) {
        int256 A1 = a.Re.mul(b.Re);
        int256 B1 = b.Im.mul(a.Re);

        int256 A2 = b.Im.mul(a.Im).mul(COEF);
        int256 B2 = a.Im.mul(b.Re);

        return newComplex(A1.add(A2), B1.add(B2));
    }

    function conjugate(Complex memory a) internal returns(Complex memory) {
        return newComplex(a.Re, -a.Im);
    }

    function scale(Complex memory a, int256 scalar) internal returns(Complex memory) {
        return newComplex(a.Re.mul(scalar), a.Im.mul(scalar));
    }

    function negative(Complex memory a) internal returns(Complex memory) {
        return newComplex(a.Re.mul(-1), a.Im.mul(-1));
    }

    struct Quaternion {
        Complex Re;
        Complex Im;
    }

    function newQuaternion(Complex memory re, Complex memory im) internal returns(Quaternion memory) {
        return Quaternion({Re: re, Im: im}); 
    }

    function add(Quaternion memory a, Quaternion memory b) internal returns(Quaternion memory) {
        return newQuaternion(a.Re.add(b.Re), a.Im.add(b.Im));
    }

    function sub(Quaternion memory a, Quaternion memory b) internal returns(Quaternion memory) {
        return newQuaternion(a.Re.sub(b.Re), a.Im.sub(b.Im));
    }

    function mul(Quaternion memory a, Quaternion memory b) internal returns(Quaternion memory) {
        Complex memory A1 = a.Re.mul(b.Re);
        Complex memory B1 = b.Im.mul(a.Re);

        Complex memory A2 = b.Im.conjugate().mul(a.Im).scale(COEF);
        Complex memory B2 = a.Im.mul(b.Re.conjugate());

        return newQuaternion(A1.add(A2), B1.add(B2));
    }

    function conjugate(Quaternion memory a) internal returns(Quaternion memory) {
        return newQuaternion(a.Re.conjugate(), a.Im.negative());
    }

    function scale(Quaternion memory a, int256 scalar) internal returns(Quaternion memory) {
        return newQuaternion(a.Re.scale(scalar), a.Im.scale(scalar));
    }

    function negative(Quaternion memory a) internal returns(Quaternion memory) {
        return newQuaternion(a.Re.scale(-1), a.Im.scale(-1));
    }

    struct Octonion {
        Quaternion Re;
        Quaternion Im;
    }

    function newOctonion(Quaternion memory re, Quaternion memory im) internal returns(Octonion memory) {
        return Octonion({Re: re, Im: im}); 
    }

    function add(Octonion memory a, Octonion memory b) internal returns(Octonion memory) {
        return newOctonion(a.Re.add(b.Re), a.Im.add(b.Im));
    }

    function sub(Octonion memory a, Octonion memory b) internal returns(Octonion memory) {
        return newOctonion(a.Re.sub(b.Re), a.Im.sub(b.Im));
    }

    function mul(Octonion memory a, Octonion memory b) internal returns(Octonion memory) {
        Quaternion memory A1 = a.Re.mul(b.Re);
        Quaternion memory B1 = b.Im.mul(a.Re);

        Quaternion memory A2 = b.Im.conjugate().mul(a.Im).scale(COEF);
        Quaternion memory B2 = a.Im.mul(b.Re.conjugate());

        return newOctonion(A1.add(A2), B1.add(B2));
    }

    function conjugate(Octonion memory a) internal returns(Octonion memory) {
        return newOctonion(a.Re.conjugate(), a.Im.negative());
    }

    function scale(Octonion memory a, int256 scalar) internal returns(Octonion memory) {
        return newOctonion(a.Re.scale(scalar), a.Im.scale(scalar));
    }

    function negative(Octonion memory a) internal returns(Octonion memory) {
        return newOctonion(a.Re.scale(-1), a.Im.scale(-1));
    }

    struct Sedenion {
        Octonion Re;
        Octonion Im;
    }

    function newSedenion(Octonion memory re, Octonion memory im) internal returns(Sedenion memory) {
        return Sedenion({Re: re, Im: im}); 
    }

    function add(Sedenion memory a, Sedenion memory b) internal returns(Sedenion memory) {
        return newSedenion(a.Re.add(b.Re), a.Im.add(b.Im));
    }

    function sub(Sedenion memory a, Sedenion memory b) internal returns(Sedenion memory) {
        return newSedenion(a.Re.sub(b.Re), a.Im.sub(b.Im));
    }

    function mul(Sedenion memory a, Sedenion memory b) internal returns(Sedenion memory) {
        Octonion memory A1 = a.Re.mul(b.Re);
        Octonion memory B1 = b.Im.mul(a.Re);

        Octonion memory A2 = b.Im.conjugate().mul(a.Im).scale(COEF);
        Octonion memory B2 = a.Im.mul(b.Re.conjugate());

        return newSedenion(A1.add(A2), B1.add(B2));
    }

    function conjugate(Sedenion memory a) internal returns(Sedenion memory) {
        return newSedenion(a.Re.conjugate(), a.Im.negative());
    }

    function scale(Sedenion memory a, int256 scalar) internal returns(Sedenion memory) {
        return newSedenion(a.Re.scale(scalar), a.Im.scale(scalar));
    }

    function negative(Sedenion memory a) internal returns(Sedenion memory) {
        return newSedenion(a.Re.scale(-1), a.Im.scale(-1));
    }
}
