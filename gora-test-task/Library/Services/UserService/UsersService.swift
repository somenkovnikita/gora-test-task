//
//  UsersService.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine
import Dispatch

final class UsersService: AnyUsersService {

    func users() -> AnyPublisher<[User], Error> {
        JSONPlacehoderAPI.fetch(usingMethod: .users)
            /* Uncomment for emulate bad network */
            //.delay(for: 1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
