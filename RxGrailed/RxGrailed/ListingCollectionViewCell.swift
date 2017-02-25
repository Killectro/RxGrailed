//
//  ListingCollectionViewCell.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxSwift

final class ListingCollectionViewCell: UICollectionViewCell {

    // MARK: Public properties

    // MARK: Private properties

    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var designerLabel: UILabel!
    @IBOutlet private var sizeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!

    private var disposeBag = DisposeBag()

    // MARK: Lifecycle

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        coverImageView.image = nil
    }

    func setup(with viewModel: ListingDisplayable) {
        viewModel.image
            .bindTo(coverImageView.rx.image)
            .disposed(by: disposeBag)

        designerLabel.text = viewModel.designer
        sizeLabel.text = viewModel.size
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
    }
}
