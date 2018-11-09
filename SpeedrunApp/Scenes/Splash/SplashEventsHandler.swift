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
	let fetchSpeedruns: FetchSpeedruns

	init (
		fetchSpeedruns: FetchSpeedruns
		) {
		self.fetchSpeedruns = fetchSpeedruns
	}

	func viewDidLoad() {
		performSpeedrunsFetch()
	}

	func performSpeedrunsFetch() {
		fetchSpeedruns
			.execute()
			.subscribe(
				onNext: {[weak self] speedruns in
					guard let state = self?.createState(withSpeedruns: speedruns) else { return }
					self?.navigation?.presentHome(for: state)
				},
				onError: { [weak self] _ in
					self?.navigation?.presentInformationPopup(
						title: "Ups!",
						message: "There was an error loading speedruns. \n Press OK to try again!",
						animated: true,
						action: {
							self?.performSpeedrunsFetch()
					}
					)
				}
			).disposed(by: disposeBag)
	}

	func createState(withSpeedruns speedruns: [Speedrun]) -> AppState {
		let speedrunsRepository = SpeedrunsRepository(speedruns: speedruns)
		return AppState( speedrunsRepository: speedrunsRepository)
	}
}
