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

protocol GrailedNetworkModelable {
    func getListings() -> Observable<[Listing]>
//    func getDetails(of: Listing)
}

struct GrailedNetworkModel: GrailedNetworkModelable {
    private let client: Client
    private let searchIndex: Index

    init() {
        client = Client(appID: "MNRWEFSS2Q", apiKey: "ce26ba82dbc20d4f25c28a2077ce159d")
        searchIndex = client.index(withName: "Listing_production")
    }

    func getListings() -> Observable<[Listing]> {
        return getListingJSON().mapArray(Listing.self, keyPath: "hits")
    }

    private func getListingJSON() -> Observable<JSONObject> {

        return Observable.create { obs in

            let query = Query(query: nil)
            query.hitsPerPage = 50

            let operation = self.searchIndex.browse(query: query) { content, error in
                if let error = error {
                    obs.onError(error)
                } else {
                    // Force unwrapping here is safe since it will always be present
                    // in this case, according to Angolia's headers
                    print(content!)
                    obs.onNext(content!)
                    obs.onCompleted()
                }
            }

            operation.start()

            return Disposables.create {
                operation.cancel()
            }
        }
    }
}
