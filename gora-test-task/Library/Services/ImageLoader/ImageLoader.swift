//
//  ImageLoader.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation
import UIKit
import Combine

final class ImageLoader {

    static let shared = ImageLoader()

    private var cache: [URL: UIImage] = [:]
    private var cacheAccessQueue = DispatchQueue(label: "image-cache-access")

    private init() {

    }

    func load(for url: URL) -> AnyPublisher<UIImage, Error> {
        return searchInCache(url)
            .flatMap { [weak self] (image: UIImage?) -> AnyPublisher<UIImage, Error> in
                if let image = image {
                    return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    guard let self = self else {
                        return Fail(error: POSIXError(.EACCES)).eraseToAnyPublisher()
                    }

                    return self.doLoadImage(for: url)
                }
            }
            .eraseToAnyPublisher()
    }

    private func searchInCache(_ url: URL) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            self?.cacheAccessQueue.async { [weak self] in
                promise(.success(self?.cache[url]))
            }
        }
        .eraseToAnyPublisher()
    }

    private func doLoadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            /* Uncomment for emulate bad network */
            //.delay(for: 1, scheduler: DispatchQueue.main)
            .tryMap() { [weak self] element -> UIImage in
                guard
                    let response = element.response as? HTTPURLResponse, response.statusCode == 200,
                    let mimeType = response.mimeType, mimeType.hasPrefix("image"),
                    let image = UIImage(data: element.data) else {
                        throw URLError(.badServerResponse)
                    }

                self?.cacheAccessQueue.async { [weak self] in
                    self?.cache[url] = image
                }

                return image
            }
            .eraseToAnyPublisher()
    }

}
