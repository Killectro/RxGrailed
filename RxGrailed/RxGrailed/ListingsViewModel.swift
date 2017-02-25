//
//  ListingsViewModel.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import RxSwift

protocol ListingsDisplayable {
    // MARK: Inputs

    /// Provides an instance of `ListingsDisplayable` with the information
    /// it needs to handle proper pagination
    ///
    /// - Parameter paginate: Triggers whenever view model should load a new page
    func setupObservables(paginate: Observable<Void>)

    // MARK: Outputs

    /// Observable list of the `Listing`s retrieved from the server
    var listings: Observable<[ListingDisplayable]>! { get set }
}

final class ListingsViewModel: ListingsDisplayable {

    // MARK: Public properties
    var listings: Observable<[ListingDisplayable]>!

    // MARK: Private properties
    private let networkModel: GrailedNetworkModelable

    // MARK: Lifecycle
    init() {
        networkModel = GrailedNetworkModel()
    }

    func setupObservables(paginate: Observable<Void>) {
        listings = networkModel
            .getListings(paginate: paginate, loadedSoFar: [])
            .map { $0.map(ListingViewModel.init) }
    }
}
