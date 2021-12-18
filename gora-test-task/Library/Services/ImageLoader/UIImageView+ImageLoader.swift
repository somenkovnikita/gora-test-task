//
//  UIImageView+ImageLoader.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine
import UIKit

extension UIImageView {

    private static var imageViewCancellabels = NSMapTable<UIImageView, AnyCancellable>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )

    func setImage(url: URL, complitionHandler: Block<Error?>?) {
        let cancellable: AnyCancellable = ImageLoader.shared.load(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    complitionHandler?(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
                complitionHandler?(nil)
            })

        Self.imageViewCancellabels.setObject(cancellable, forKey: self)
    }

}
