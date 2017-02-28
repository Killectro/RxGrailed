//
//  ListingsViewModelSpec.swift
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
@testable
import RxGrailed

func testListingJSON() -> [String : Any] {
    return [
        "id" : 12345,
        "retina_cover_photo" : [
            "url" : "https://www.google.com"
        ],
        "price_i" : 300,
        "designer_names" : "Supreme",
        "title" : "Supreme Brick",
        "description" : "Literally just a brick",
        "size" : "one size",
        "user" : [
            "username" : "not_YMBAPE"
        ]
    ]
}

class ListingsViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ListingsViewModel!
        var paginate: PublishSubject<Void>!
        var disposeBag: DisposeBag!

        beforeEach {
            viewModel = ListingsViewModel(networkModel: MockGrailedNetworkModel())
            paginate = PublishSubject()
            disposeBag = DisposeBag()
        }

        it("loads a first page") {
            viewModel.setupObservables(paginate: paginate.asObservable())

            waitUntil { done in
                viewModel.listings
                    .subscribe(onNext: { listings in
                        expect(listings).toNot(beEmpty())
                        expect(listings.count) == 5
                        done()
                    })
                    .disposed(by: disposeBag)
            }
        }

        it("loads a second page when pagination occurs") {
            viewModel.setupObservables(paginate: paginate.asObservable())

            waitUntil { done in
                viewModel.listings
                    .mapWithIndex { ($0, $1) }
                    .subscribe(onNext: { listings, index in
                        expect(listings).toNot(beEmpty())
                        expect(listings.count) == 5 * (index + 1)

                        if index == 1 {
                            done()
                        }
                    })
                    .disposed(by: disposeBag)

                paginate.onNext(())
            }
        }

    }
}

private class MockGrailedNetworkModel: GrailedNetworkModelable {
    fileprivate func getListings(paginate: Observable<Void>, loadedSoFar: [Listing]) -> Observable<[Listing]> {

        let listings = (0..<5).map { _ in
            try! Listing(
                map: Mapper(JSON: testListingJSON() as NSDictionary)
            )
        }

        return Observable.of(listings).flatMap { listings -> Observable<[Listing]> in
            let newListings = loadedSoFar + listings

            let obs = [
                // Return our current list of Listings
                Observable.just(newListings),

                // Wait until we are told to paginate
                Observable.never().takeUntil(paginate),

                // Retrieve the next list of listings
                self.getListings(paginate: paginate, loadedSoFar: newListings)
            ]
            
            return Observable.concat(obs)
        }
    }
}
