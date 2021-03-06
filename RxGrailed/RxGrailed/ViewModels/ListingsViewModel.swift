//
//  ListingsViewModel.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import RxSwift

/// Defines the basic set of inputs and outputs necessary to display a list of `Listing`s
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
    init(networkModel: GrailedNetworkModelable) {
        self.networkModel = networkModel
    }

    func setupObservables(paginate: Observable<Void>) {
        listings = networkModel
            .getListings(paginate: paginate, loadedSoFar: [])
            .map { $0.map(ListingViewModel.init) }
    }
}
