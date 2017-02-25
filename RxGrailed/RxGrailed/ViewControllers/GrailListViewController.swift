//
//  GrailListViewController.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxSwift

final class GrailListViewController: UIViewController {

    // MARK: Public properties

    // MARK: Private properties

    @IBOutlet private var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private var networkModel: GrailedNetworkModel!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        networkModel = GrailedNetworkModel()

        networkModel
            .getListings()
            .subscribe()
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
