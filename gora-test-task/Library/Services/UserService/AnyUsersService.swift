//
//  AnyUsersService.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine

protocol AnyUsersService {

    func users() -> AnyPublisher<[User], Error>

}
