//
//  UserCellViewModel.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation

struct UserCellViewModel: Hashable {

    let id = UUID()
    let userName: String
    let onSelect: EmptyBlock?

    // MARK: - Hashable

    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
