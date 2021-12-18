//
//  PhotosBuilder.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

final class PhotosBuilder {

    // MARK: - Public Types

    typealias Module = (
        view: PhotosViewController,
        input: PhotosInput
    )

    // MARK: - Public Methods

    func build(userId: Int, output: PhotosOutput? = nil) -> Module {
        let view = PhotosViewController()
        let router = PhotosRouter()
        let presenter = PhotosPresenter(userId: userId, photosService: UserPhotosService())

        view.output = presenter
        presenter.output = output

        presenter.view = view
        presenter.router = router

        router.view = view

        return (view: view, input: presenter)
    }

}
