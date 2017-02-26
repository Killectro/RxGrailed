//
//  Listing.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Mapper
import Foundation

struct Listing {
    /// The unique ID of the `Listing`
    let id: Int

    /// The cover image's URL
    let imageUrl: URL

    /// The integer price of the `Listing`
    let price: Int

    /// The brand/designer name
    let designer: String

    /// The title
    let title: String

    /// The full description
    let description: String

    /// Sizing information
    let size: String

    /// The seller's name
    let sellerName: String
}

extension Listing: Mappable {
    init(map: Mapper) throws {
        self.id = try map.from("id")
        self.imageUrl = try map.from("retina_cover_photo.url")
        self.price = try map.from("price_i")
        self.designer = try map.from("designer_names")
        self.title = try map.from("title")
        self.description = try map.from("description")
        self.size = try map.from("size")
        self.sellerName = try map.from("user.username")
    }
}
