//
//  ListingViewModel.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

/// Defines the basic information necessary to display a listing
protocol ListingDisplayable {
    var image: Driver<UIImage?> { get }
    var price: String { get }
    var designer: String { get }
    var title: String { get }
    var description: String { get }
    var size: String { get }
    var titleAndSize: String { get }
    var sellerName: String { get }
}

final class ListingViewModel: ListingDisplayable {

    // MARK: Public properties

    let image: Driver<UIImage?>
    let price: String
    let designer: String
    let title: String
    let description: String
    let size: String
    let titleAndSize: String
    let sellerName: String

    // MARK: Private properties

    private let listing: Listing

    // MARK: Initialization

    init(listing: Listing) {
        self.listing = listing

        image = KingfisherManager.shared.rx
            .image(URL: listing.imageUrl, optionsInfo: [.backgroundDecode])
            .retry(3)
            .map(Optional.some)
            // When an image fetch is cancelled it returns an error, but we don't want to
            // bind that error to our UI so we catch it here and just return `nil`
            .asDriver(onErrorJustReturn: nil)

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0

        // Force unwrap here is safe because we have an integer, which
        // can always be turned into a currency value
        price = formatter.string(from: listing.price as NSNumber)!

        designer = listing.designer.uppercased()
        title = listing.title
        description = listing.description
        size = listing.size.uppercased()

        titleAndSize = title + " size " + size
        sellerName = listing.sellerName.uppercased()
    }
}
