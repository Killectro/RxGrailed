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

protocol ListingDisplayable {
    var image: Driver<UIImage?> { get }
    var price: String { get }
    var designer: String { get }
    var title: String { get }
    var description: String { get }
    var size: String { get }
}

final class ListingViewModel: ListingDisplayable {

    // MARK: Public properties

    let image: Driver<UIImage?>
    let price: String
    let designer: String
    let title: String
    let description: String
    let size: String

    // MARK: Private properties

    let listing: Listing

    // MARK: Initialization

    init(listing: Listing) {
        self.listing = listing

        image = KingfisherManager.shared.rx
            .image(URL: listing.imageUrl, optionsInfo: [.backgroundDecode])
            .map(Optional.some)
            .asDriver(onErrorJustReturn: nil)

        price = String(format: "$%d", listing.price)
        designer = listing.designer.uppercased()
        title = listing.title
        description = listing.description
        size = listing.size.uppercased()
    }
}