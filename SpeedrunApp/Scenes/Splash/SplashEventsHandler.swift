//
//  SplashEventsHandler.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import RxSwift

class SplashEventsHandler {
	weak var navigation : SplashNavigation?
	private let disposeBag: DisposeBag = DisposeBag ()
	let fetchGames: FetchGames

	init (
		fetchGames: FetchGames
	) {
		self.fetchGames = fetchGames
	}

	func viewDidLoad() {
		performGamesFetch()
	}

	func performGamesFetch() {
		fetchGames
			.execute()
			.subscribe(
				onNext: {[weak self] games in
					guard let state = self?.createState(withGames: games) else { return }
					self?.navigation?.presentHome(for: state)
				},
				onError: { [weak self] _ in
					self?.navigation?.presentInformationPopup(
						title: "Ups!",
						message: "There was an error loading games. \n Press OK to try again!",
						animated: true,
						action: {
							self?.performGamesFetch()
					}
					)
				}
			).disposed(by: disposeBag)
	}

	func createState(withGames games: [Game]) -> AppState {
		let gamesRepository = GamesRepository(games: games)
		return AppState( gamesRepository: gamesRepository)
	}
}
