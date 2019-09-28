//
//  CardBrandTests.swift
//  FrameworkTests
//
//  Created by Vitalii Obertynskyi on 9/28/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

import XCTest
@testable import VGSFramework

class CardBrandTests: XCTestCase {

    func testVisa() {
        let brand = CardBrand.visa
        let patter = "^4[0-9]{12}(?:[0-9]{3})?$"
        
        XCTAssertTrue(brand.patter == patter)
        XCTAssert(brand.patter.first == "^")
        XCTAssert(brand.patter.last == "$")
    }
    
    func testMastercard() {
        let brand = CardBrand.mastercard
        let patter = "^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$"
        
        XCTAssertTrue(brand.patter == patter)
        XCTAssert(brand.patter.first == "^")
        XCTAssert(brand.patter.last == "$")
    }
    
    func testAmex() {
        let brand = CardBrand.amex
        let patter = "^(3[47][0-9]{13})$"
        
        XCTAssertTrue(brand.patter == patter)
        XCTAssert(brand.patter.first == "^")
        XCTAssert(brand.patter.last == "$")
    }
}
