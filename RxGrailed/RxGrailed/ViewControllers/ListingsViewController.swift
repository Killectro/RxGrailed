//
//  ListingsViewController.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ListingsViewController: UIViewController {

    // MARK: Public properties

    // MARK: Private properties

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
            let spacing: CGFloat = 16.0

            layout?.minimumInteritemSpacing = spacing
            layout?.itemSize = CGSize(
                width: (UIScreen.main.bounds.width - spacing) / 2,
                height: 224
            )
        }
    }
 
    private let disposeBag = DisposeBag()
    private var viewModel: ListingsDisplayable!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        KingfisherManager.shared.cache.clearDiskCache()

        viewModel = ListingsViewModel()

        let paginate = collectionView.rx.contentOffset
            .map { [weak self] _ -> Bool in
                guard let `self` = self else { return false }

                return self.collectionView.isNearBottom(threshold: 200)
            }
            .distinctUntilChanged()
            .filter { $0 }
            .throttle(0.5, scheduler: MainScheduler.instance) // Prevent an edge case where it figured multiple times in a row
            .map { _ in () }

        viewModel.setupObservables(paginate: paginate)
        viewModel
            .listings
            .bindTo(collectionView.rx.items(cellIdentifier: "listingCell", cellType: ListingCollectionViewCell.self)) { _, viewModel, cell in
                cell.setup(with: viewModel)
            }
            .disposed(by: disposeBag)
    }
}
