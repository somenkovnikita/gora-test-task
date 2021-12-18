//
//  UsersPresenter.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine
import Dispatch

final class UsersPresenter {

    // MARK: - Public Properties

    weak var view: UsersViewInput?
    var router: UsersRouterInput?
    var output: UsersOutput?

    private let usersService: AnyUsersService

    private var cancellables: Set<AnyCancellable> = []

    init(usersService: AnyUsersService) {
        self.usersService = usersService
    }

}

// MARK: - UsersViewOutput

extension UsersPresenter: UsersViewOutput {

    func ready() {
        startLoadingUsers()
    }

}

// MARK: - UsersInput

extension UsersPresenter: UsersInput {

}

// MARK: - Private methods

private extension UsersPresenter {

    private func startLoadingUsers() {
        view?.configure(state: .loading)

        usersService.users()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.view?.configure(state: .error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] users in
                self?.handleSuccessLoading(users)
            })
            .store(in: &cancellables)
    }

    private func handleSuccessLoading(_ users: [User]) {
        let userViewModels = users.map { user in
            return UserCellViewModel(
                userName: user.name,
                onSelect: { [weak self] in
                    self?.router?.showUserPhotos(id: user.id)
                }
            )
        }

        view?.configure(state: .data(userViewModels))
    }

}
