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
    let id: Int
    let imageUrl: URL
    let price: Int
    let designer: String
    let title: String
    let description: String
    let size: String
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
    }
}
