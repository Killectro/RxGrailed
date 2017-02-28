//
//  ListingSpec.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/28/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mapper
@testable
import RxGrailed

class ListingSpec: QuickSpec {
    override func spec() {

        var subject: Listing!

        beforeEach {
            let json = testListingJSON() as NSDictionary
            subject = try! Listing(map: Mapper(JSON: json))
        }

        it("has all of its properties") {
            expect(subject).toNot(beNil())

            expect(subject.id) == 12345
            expect(subject.imageUrl.absoluteString) == "https://www.google.com"
            expect(subject.price) == 300
            expect(subject.designer) == "Supreme"
            expect(subject.title) == "Supreme Brick"
            expect(subject.description) == "Literally just a brick"
            expect(subject.size) == "one size"
            expect(subject.sellerName) == "not_YMBAPE"
        }
    }
}
