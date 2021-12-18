//
//  State.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation

enum State<T> {

    case loading
    case error
    case empty
    case data(T)

}
