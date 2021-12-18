//
//  UsersBuilder.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

final class UsersBuilder {

    // MARK: - Public Types

    typealias Module = (
        view: UsersViewController,
        input: UsersInput
    )

    typealias NavigatableModule = (
        view: UINavigationController,
        input: UsersInput
    )

    // MARK: - Public Methods

    func build(output: UsersOutput? = nil) -> Module {
        let view = UsersViewController()
        let router = UsersRouter()
        let presenter = UsersPresenter(usersService: UsersService())

        view.output = presenter
        presenter.output = output

        presenter.view = view
        presenter.router = router

        router.view = view

        return (view: view, input: presenter)
    }

    func buildWithNavigation(output: UsersOutput? = nil) -> NavigatableModule {
        let module = build(output: output)

        let navigationController = UINavigationController(rootViewController: module.view)

        return (view: navigationController, input: module.input)
    }

}
