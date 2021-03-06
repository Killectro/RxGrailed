//
//  GrailedNetworkModel.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import AlgoliaSearch
import RxSwift

/// Protocol that represents the entirety of `RxGrailed`'s networking capabilities.
/// In a production app this would be split into network models for each controller, but
/// here that is unnecessary
protocol GrailedNetworkModelable {

    /// Returns an observable of `Listing`s retrieved from the backend
    ///
    /// - Parameters:
    ///   - paginate: Observable that triggers when the network model should trigger another request
    ///   - loadedSoFar: The list of `Listing`s loaded thus far. Should start as an empty array
    /// - Returns: An `Observable<[Listing]>` that has all of the `Listing` objects received from the backend
    func getListings(paginate: Observable<Void>, loadedSoFar: [Listing]) -> Observable<[Listing]>
}

struct GrailedNetworkModel: GrailedNetworkModelable {
    fileprivate let client: Client
    fileprivate let searchIndex: Index

    init() {
        client = Client(appID: "MNRWEFSS2Q", apiKey: "ce26ba82dbc20d4f25c28a2077ce159d")
        searchIndex = client.index(withName: "Listing_production")
    }

    func getListings(paginate: Observable<Void>, loadedSoFar: [Listing]) -> Observable<[Listing]> {
        return getMoreListings().flatMap { newPage -> Observable<[Listing]> in

            let newListings = loadedSoFar + newPage

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

private extension GrailedNetworkModel {
    private static var cursor: String? = nil


    /// Retrieves raw JSON from the Algolia backend
    ///
    /// - Returns: An Observable of JSON
    func getListingJSON() -> Observable<JSONObject> {

        return Observable.create { obs in

            let completion: (JSONObject?, Error?) -> () = { content, error in
                if let error = error {
                    obs.onError(error)
                } else {
                    GrailedNetworkModel.cursor = content?["cursor"] as? String

                    // Force unwrapping here is safe since it will always be present
                    // in this case, according to Algolia's headers
                    obs.onNext(content!)
                    obs.onCompleted()
                }
            }

            if let cursor = GrailedNetworkModel.cursor {
                let operation = self.searchIndex.browse(from: cursor, completionHandler: completion)

                return Disposables.create {
                    operation.cancel()
                }
            } else {
                let query = Query(query: nil)
                query.hitsPerPage = 50

                let operation = self.searchIndex.browse(query: query, completionHandler: completion)

                return Disposables.create {
                    operation.cancel()
                }
            }
        }
    }

    /// Retrieves a single page of `Listing` objects
    ///
    /// - Returns: An `Observable` of a single page of listings
    func getMoreListings() -> Observable<[Listing]> {
        return getListingJSON()
            .subscribeOn(MainScheduler.instance)
            .do(onSubscribe: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .mapArray(Listing.self, keyPath: "hits")
            .retry(3)
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, onError: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .shareReplay(1)
    }
}
