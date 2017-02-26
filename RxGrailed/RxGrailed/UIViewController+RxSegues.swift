//
//  UIViewController+RxSegues.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

    /// Observable sequence that triggers whenever a segue is performed with `Base` as it's source and
    /// a controller with type `V` as its destination.
    ///
    /// - Parameters:
    ///   - to: The type of the destination view controller
    ///   - with: The type, if any, of `sender`
    /// - Returns: The controller and the related model
    func segue<V: UIViewController, Model>(to: V.Type, with: Model.Type?) -> Observable<(V, Model)> {
        return methodInvoked(#selector(UIViewController.prepare(for:sender:)))
            .flatMap { array -> Observable<(V, Model)> in
                guard
                    let segue = array[safe: 0] as? UIStoryboardSegue,
                    let destination = segue.destination as? V,
                    let model = array[safe: 1] as? Model else { return Observable.empty() }

                return Observable.just((destination, model))
        }
    }
}
