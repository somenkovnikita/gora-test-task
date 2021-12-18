//
//  UserCell.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation
import UIKit

final class UserCell: UITableViewCell {

    func configure(with viewModel: UserCellViewModel) {
        var configuration = defaultContentConfiguration()

        configuration.text = viewModel.userName

        accessoryType = .disclosureIndicator
        contentConfiguration = configuration
    }

}
