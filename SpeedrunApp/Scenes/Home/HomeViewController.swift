//
//  HomeViewController.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeView {
	func setGames( _ games: [GameToDisplay] )
}

protocol HomeViewEventsEmitter {
	var gameSelectedObservable: Observable<GameToDisplay> { get }
}

class HomeViewController:
	ObservableViewController,
	HomeView,
	HomeViewEventsEmitter
{
	@IBOutlet weak var gamesCollectionView: GamesCollectionView!
	@IBOutlet weak var emptyView: UIView!

	var gameSelectedObservable: Observable<GameToDisplay> {
		return gamesCollectionView.selectedGameObservable
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Speedruns"
	}
	
	func setGames( _ games: [GameToDisplay] ) {
		//Shows a view notifying when there were no results
		emptyView.isHidden = !(games.count == 0)
		gamesCollectionView.games = games
		gamesCollectionView.reloadData()
	}
}
