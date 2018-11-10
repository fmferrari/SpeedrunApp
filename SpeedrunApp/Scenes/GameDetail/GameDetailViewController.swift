//
//  GameDetailViewController.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.

import UIKit
import Kingfisher

protocol GameDetailView {
	func setGameInformation( _ gameDetails: GameDetailsToDisplay )
	func showLoadingView ()
	func showErrorView ()
	func hideErrorView ()
	func hideLoadingView ()
}

class GameDetailViewController: ObservableViewController, GameDetailView {

	@IBOutlet weak var gameImageViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomInformationViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var gameImageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var gameImageView: UIImageView!
	@IBOutlet weak var topInformationView: UIView!
	@IBOutlet weak var bottomInformationView: UIView!
	@IBOutlet weak var goToVideoView: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var playerLabel: UILabel!
	@IBOutlet weak var goToVideoLabel: UILabel!
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var errorView: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var originalImageView : UIImageView?
	
	func setGameInformation(_ gameDetails: GameDetailsToDisplay) {
		navigationItem.title = gameDetails.game.name
		setGameImage(url: gameDetails.game.logo)
		timeLabel.text = gameDetails.time
		playerLabel.text = gameDetails.player
		setupBackgroundViews()
	}

	func setupBackgroundViews() {
		bottomInformationView.layer.cornerRadius = 20
		topInformationView.layer.cornerRadius = 20
		goToVideoView.layer.cornerRadius = 20
	}

	func setGameImage( url: URL ) {
		gameImageView.kf.setImage(with: url) { [weak self] image,_,_,_ in
			guard let sSelf = self,
					let image = image
			else { return }
			sSelf.gameImageView.layer.cornerRadius = 20
			let ratio = image.size.height / image.size.width
			sSelf.gameImageViewHeightConstraint.constant = (UIScreen.main.bounds.width - 32) * ratio
			sSelf.view.layoutSubviews()
		}
	}

	func showLoadingView() {
		loadingView.isHidden = false
		activityIndicator.startAnimating()
		view.bringSubviewToFront(loadingView)
	}

	func hideLoadingView() {
		loadingView.isHidden = true
		activityIndicator.stopAnimating()
	}

	func showErrorView() {
		errorView.isHidden = false
		view.bringSubviewToFront(errorView)
	}

	func hideErrorView() {
		errorView.isHidden = true
	}
}
