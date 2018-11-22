//
//  ReviewViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// The `ReviewViewController` offers an interface to review the image after it has been cropped and deskwed according to the passed in quadrilateral.
final class ReviewViewController: UIViewController {
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
//        imageView.image = results.scannedImage
        imageView.image = results.scannedImage.filter(name: "CILinearToSRGBToneCurve", parameters: [String : Any]())
        imageView.isHighlighted = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var doneButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.review.button.done", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Done", comment: "A generic done button")
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(finishScan))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    lazy private var restoreButton: UIButton = {
        let restoreButton = UIButton()
        restoreButton.setTitle("Restore", for: .normal)
        restoreButton.setTitleColor(UIColor.white, for: .normal)
        restoreButton.addTarget(self, action: #selector(restoreButtonClick), for: .touchUpInside)
        return restoreButton
    }()
    private let results: ImageScannerResults
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults) {
        self.results = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        
        title = NSLocalizedString("wescan.review.title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Review", comment: "The review title of the ReviewController")
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: Setups
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(restoreButton)
    }
    
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        restoreButton.frame = CGRect(x: 10, y: 30, width: 100, height: 100)
    }
    
    // MARK: - Actions
    
    @objc private func finishScan() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        var newResults = results
        newResults.scannedImage = results.scannedImage
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: newResults)
    }
    @objc func restoreButtonClick(){
        restoreButton.isSelected = !restoreButton.isSelected
        if restoreButton.isSelected{
            imageView.image = results.scannedImage
            restoreButton.setTitle("Filter", for: .normal)
        }else{
            imageView.image = results.scannedImage.filter(name: "CILinearToSRGBToneCurve", parameters: [String : Any]())
            restoreButton.setTitle("Restore", for: .normal)
        }
    }

}
