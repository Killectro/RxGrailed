//
//  UIScrollView+IsNearBottom.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// Determines whether or not the the scroll view is within a certain threshold of the bottom.
    /// Can be used to determine whether or not it is appropriate to paginate.
    /// Will return no if it is within the `threshold` value but the content size doesn't reach the bottom of the scroll
    /// view frame
    ///
    /// - Parameter threshold: The maximum distance from the bottom before we should paginate
    /// - Returns: Whether the content is within `threshold` points of the bottom of the content.
    func isNearBottom(threshold: CGFloat) -> Bool {
        let isAtBottom = contentOffset.y + frame.height + threshold > contentSize.height
        let hasContent = contentSize.height > frame.height

        return isAtBottom && hasContent
    }
}
