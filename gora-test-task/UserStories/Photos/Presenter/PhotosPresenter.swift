//
//  PhotosPresenter.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine
import Dispatch

final class PhotosPresenter {

    // MARK: - Public Properties

    weak var view: PhotosViewInput?
    var router: PhotosRouterInput?
    var output: PhotosOutput?

    private let photosService: AnyUserPhotosService
    private let userId: Int

    private var cancellabels: Set<AnyCancellable> = []

    init(userId: Int, photosService: AnyUserPhotosService) {
        self.userId = userId
        self.photosService = photosService
    }

}

// MARK: - PhotosViewOutput

extension PhotosPresenter: PhotosViewOutput {

    func ready() {
        startLoadingPhotos()
    }

}

// MARK: - PhotosInput

extension PhotosPresenter: PhotosInput {

}

// MARK: - Private methods

private extension PhotosPresenter {

    private func startLoadingPhotos() {
        view?.configure(state: .loading)

        photosService.photos(for: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self?.view?.configure(state: .error)
                }
            }, receiveValue: { [weak self] photos in
                self?.handleSuccessLoading(photos)
            })
            .store(in: &cancellabels)
    }

    private func handleSuccessLoading(_ photos: [Photo]) {
        let photoViewModels = photos.map { (photo: Photo) -> PhotoCellViewModel in
            PhotoCellViewModel(title: photo.title, image: photo.url)
        }

        view?.configure(state: .data(photoViewModels))
    }
}
