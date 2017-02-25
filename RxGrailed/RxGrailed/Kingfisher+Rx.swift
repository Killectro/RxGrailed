//
//  Kingfisher+Rx.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift

extension KingfisherManager: ReactiveCompatible {}

extension Reactive where Base: KingfisherManager {

    func image(
        URL: URL,
        optionsInfo: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil
        ) -> Observable<UIImage> {

        return Observable.create({ obs in
            let task = self.base.retrieveImage(with: URL, options: optionsInfo, progressBlock: progressBlock, completionHandler: { (image, error, _, _) in
                if let image = image {
                    obs.onNext(image)
                    obs.onCompleted()
                } else {
                    obs.onError(error!)
                }
            })

            return Disposables.create {
                task.cancel()
            }
        })
    }
}
