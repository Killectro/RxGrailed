//
//  ListingViewModelSpec.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/28/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mapper
import RxSwift
import RxCocoa
@testable
import RxGrailed

class ListingviewModelSpec: QuickSpec {
    override func spec() {
        var subject: ListingViewModel!
        let json = testListingJSON() as NSDictionary
        let listing = try! Listing(map: Mapper(JSON: json))
        var disposeBag: DisposeBag!

        beforeEach {
            subject = ListingViewModel(listing: listing)
            disposeBag = DisposeBag()
        }

        it("has an image") {
            waitUntil(timeout: 10.0) { done in
                subject
                    .image
                    .drive(onNext: { image in
                        expect(image).toNot(beNil())
                        done()
                    })
                    .disposed(by: disposeBag)
            }
        }

        it("correctly formats price") {
            // Assume USD
            expect(subject.price) == "$300"
        }

        it("correctly formats designer") {
            expect(subject.designer) == "SUPREME"
        }

        it("correctly formats title") {
            expect(subject.title) == "Supreme Brick"
        }

        it("correctly formats description") {
            expect(subject.description) == "Literally just a brick"
        }

        it("correctly formats size") {
            expect(subject.size) == "ONE SIZE"
        }

        it("correctly formats title and size") {
            expect(subject.titleAndSize) == "Supreme Brick size ONE SIZE"
        }

        it("correctly formats seller name") {
            expect(subject.sellerName) == "NOT_YMBAPE"
        }
    }
}
