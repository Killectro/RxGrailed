//
//  ListingDetailViewController.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListingDetailViewController: UIViewController {

    // MARK: Public properties

    var viewModel: ListingDisplayable!

    // MARK: Private properties

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var designerLabel: UILabel!
    @IBOutlet private var titleAndSizeLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var sellerNameLabel: UILabel!

    private let disposeBag = DisposeBag()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        viewModel.image
            .drive(coverImageView.rx.image)
            .disposed(by: disposeBag)

        designerLabel.text = viewModel.designer
        titleAndSizeLabel.text = viewModel.titleAndSize
        priceLabel.text = viewModel.price
        descriptionLabel.text = viewModel.description
        sellerNameLabel.text = viewModel.sellerName

        navigationItem.title = viewModel.designer
    }
}
