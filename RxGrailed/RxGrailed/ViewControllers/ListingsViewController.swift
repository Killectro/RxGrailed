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
import RxOptional
import Kingfisher

final class ListingsViewController: UIViewController {

    // MARK: Public properties

    var viewModel: ListingsDisplayable!

    lazy var didSelectViewModel: Driver<ListingDisplayable> = self._didSelectViewModel.asDriver().filterNil()

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

    private let _didSelectViewModel = Variable<ListingDisplayable?>(nil)
    private let disposeBag = DisposeBag()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        let paginate = collectionView.rx.didScroll
            .filter { [weak self] offset in
                guard let `self` = self else { return false }

                return self.collectionView.isNearBottom(threshold: 200)
            }
            // If we don't skip, after paginating once the network model will subscribe again and receive
            // another `onNext` event, which will trigger another pagination request
            .skip(1)

        viewModel.setupObservables(paginate: paginate)

        viewModel
            .listings
            .bindTo(collectionView.rx.items(cellIdentifier: "listingCell", cellType: ListingCollectionViewCell.self)) { _, viewModel, cell in
                cell.setup(with: viewModel)
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .modelSelected(ListingDisplayable.self)
            .bindTo(_didSelectViewModel)
            .disposed(by: disposeBag)
    }
}
