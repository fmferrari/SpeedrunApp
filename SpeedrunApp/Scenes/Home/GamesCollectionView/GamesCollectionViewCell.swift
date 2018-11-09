//
//  SpeedrunsCollectionViewCell.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//
import Kingfisher
import UIKit

class GamesCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var gameImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	var game : GameToDisplay?
	
	public func reload() {
		guard let game = game else { return }
		nameLabel.text = game.name
		gameImageView.kf.setImage(with: game.logo)
	}

}
