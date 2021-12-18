//
//  PhotoCellViewModel.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation
import Combine
import UIKit

final class PhotoCellViewModel: Hashable {

    var id = UUID()
    var image: URL
    var title: String

    init(title: String, image: URL) {
        self.title = title
        self.image = image
    }

    // MARK: - Hashable

    static func == (lhs: PhotoCellViewModel, rhs: PhotoCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
