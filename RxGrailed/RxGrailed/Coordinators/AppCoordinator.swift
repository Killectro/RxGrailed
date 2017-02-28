//
//  AppCoordinator.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/// This is a super bare implementation of a Coordinator pattern. In production code this would likely be much more robust including having children coordinators for each separate subsection of the application
struct AppCoordinator {

    private let window: UIWindow?
    private let disposeBag = DisposeBag()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navigationController = getHomeNavigationController()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let viewController = navigationController.viewControllers.first as! ListingsViewController

        viewController.viewModel = ListingsViewModel(networkModel: GrailedNetworkModel())

        viewController
            .didSelectViewModel
            .drive(onNext: { [weak viewController] viewModel in
                viewController?.performSegue(withIdentifier: "ListingsToListingDetailSegue", sender: viewModel)
            })
            .disposed(by: disposeBag)

        viewController.rx
            .segue(to: ListingDetailViewController.self, with: ListingDisplayable.self)
            .subscribe(onNext: { detail, viewModel in
                detail.viewModel = viewModel
            })
            .disposed(by: disposeBag)
    }
}

private extension AppCoordinator {

    /// Retrieves the home screen naviagation controller from the main storyboard
    ///
    /// - Returns: The navigation controller
    func getHomeNavigationController() -> UINavigationController {
        guard let navigationController = UIStoryboard.main.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Incorrect Storyboard setup, `UINavigationController` expected as initial view controller")
        }

        return navigationController
    }
}
