//
//  ViewController.swift
//  Image Search
//
//  Created by Matt Rayls on 8/9/17.
//  Copyright © 2017 Matt Rayls. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ImageFetchDelegate {
	
	let searchController = SearchController.shared

	@IBOutlet weak var searchCollectionView: UICollectionView!
	let activityIndicator = UIActivityIndicatorView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		searchController.imageFetchDelegate = self
		searchController.makeRequest()
		setupActivityIndicator()
	}
	
	override func viewWillAppear(_ animated: Bool) {

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupActivityIndicator() {
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .whiteLarge
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		activityIndicator.center = self.view.center
	}
	
	func loadCollectionViewData() {
		print("Loading Collection data")
		searchCollectionView.reloadData()
		searchCollectionView.isHidden = false
		activityIndicator.stopAnimating()
	}
	
	func showAlertError(errorMessage: String) {
		// TODO Show alert with error message
		let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of items
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
		cell.layer.cornerRadius = 5
		cell.layer.borderColor = UIColor.white.cgColor
		cell.layer.borderWidth = 0.5
		// Check to make sure that we won't get a crash for an invalid index
		guard searchController.photos.count > 0 else {
			return cell
		}
		
		cell.imageTitleLabel.text = searchController.photos[indexPath.row].name
		searchController.getImage(imageURL: URL(string:searchController.photos[indexPath.row].imageURL!)!, completion: { image in
			cell.searchImageView.image = image
		})
		
		return cell
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		// Called just so we can realign the activity indicator to the center
		coordinator.animate(alongsideTransition: { _ in
			self.activityIndicator.center = self.view.center
		}, completion: nil)
		
	}
	
}
