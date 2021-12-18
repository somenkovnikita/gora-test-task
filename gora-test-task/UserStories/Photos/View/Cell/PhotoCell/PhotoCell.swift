//
//  PhotoCell.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

final class PhotoCell: UITableViewCell {

    // MARK: - Subviews

    private let activityIndicatorView = UIActivityIndicatorView()
    private let photoImageView = UIImageView()
    private let photoTitleLabel = UILabel()
    private let containerView = UIView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }

    // MARK: - Public Methods

    func configure(with viewModel: PhotoCellViewModel) {
        photoTitleLabel.text = viewModel.title

        self.activityIndicatorView.startAnimating()
        photoImageView.image = nil

        photoImageView.setImage(url: viewModel.image, complitionHandler: { [weak self] error in
            if error != nil{
                /* show error state here */
            }

            self?.activityIndicatorView.stopAnimating()
        })
    }

    // MARK: - Private Methods

    private func configureAppearance() {
        configureView()
        configureContraints()
    }

    private func configureView() {
        selectionStyle = .none

        contentView.addSubview(containerView)

        containerView.addSubview(photoImageView)
        containerView.addSubview(photoTitleLabel)
        containerView.addSubview(activityIndicatorView)

        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 4
        photoImageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]

        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = .systemBackground

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 1

        photoTitleLabel.font = .preferredFont(forTextStyle: .caption1)
        photoTitleLabel.numberOfLines = 0
    }

    private func configureContraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),

            photoTitleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            photoTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            photoTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            photoTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }

}
