//
//  UITableView+Registation.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation
import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_ class: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: `class`))
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass class: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: `class`)

        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("developer error: cell \(identifier) is not register yet")
        }

        return cell
    }

}
