//
//  AnyUserPhotosService.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine

protocol AnyUserPhotosService {

    func photos(for userId: Int) -> AnyPublisher<[Photo], Error>

}
