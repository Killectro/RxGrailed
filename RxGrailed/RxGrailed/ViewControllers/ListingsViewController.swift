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

final class ListingsViewController: UIViewController {

    // MARK: Public properties

    // MARK: Private properties

    @IBOutlet private var collectionView: UICollectionView!
 
    private let disposeBag = DisposeBag()
    private var viewModel: ListingsDisplayable!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ListingsViewModel()

        viewModel.setupObservables(paginate: Observable.never())
        viewModel
            .listings
            .bindTo(collectionView.rx.items(cellIdentifier: "listingCell", cellType: ListingCollectionViewCell.self)) { _, viewModel, cell in
                cell.setup(with: viewModel)
            }
            .disposed(by: disposeBag)
    }
}
