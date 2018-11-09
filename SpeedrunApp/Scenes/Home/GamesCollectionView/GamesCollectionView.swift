//
//  GamesCollectionView.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//
import RxSwift
import RxCocoa
import UIKit

class GamesCollectionView: UICollectionView {
	var games : [GameToDisplay] = []

	let cellIdentifier = "GameCell"

	override func awakeFromNib() {
		super.awakeFromNib()
		self.dataSource = self
		self.delegate = self
		self.register(
			UINib.init(nibName: "GamesCollectionViewCell", bundle: nil),
			forCellWithReuseIdentifier: cellIdentifier
		)
	}

	var selectedGameObservable: Observable<GameToDisplay> {
		return self.rx.itemSelected.asObservable()
			.map { indexPath in
				self.games[indexPath.row]
		}
	}
}

extension GamesCollectionView: UICollectionViewDataSource {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int
	{
		return games.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell
	{
		guard let cell = self.dequeueReusableCell(
			withReuseIdentifier: cellIdentifier,
			for: indexPath
		) as? GamesCollectionViewCell else { return UICollectionViewCell() }

		cell.game = games[indexPath.row]
		cell.reload()
		return cell
	}
}

extension GamesCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize
	{
		let screenWidth = UIScreen.main.bounds.width
		return CGSize(width: screenWidth / 2, height: screenWidth / 2)
	}
}
