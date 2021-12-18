//
//  UsersRouter.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

final class UsersRouter {

    // MARK: - Public Properties

    weak var view: UIViewController?

}

// MARK: - UsersRouterInput

extension UsersRouter: UsersRouterInput {

    func showUserPhotos(id: Int) {
        let module = PhotosBuilder().build(userId: id, output: nil)
        view?.navigationController?.pushViewController(module.view, animated: true)
    }

}
