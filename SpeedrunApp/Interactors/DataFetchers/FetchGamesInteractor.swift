//
//  FetchGamesInteractor.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit
import RxSwift

protocol FetchGames: class {
	func execute() -> Observable<[Game]>
}

enum FetchGamesInteractorError: Error {
	case invalidResponse
}

class FetchGamesInteractor: FetchGames {

	static var withDefaultApi: FetchGamesInteractor {
		return FetchGamesInteractor (api: SpeedrunApi.shared)
	}

	let api: SpeedrunApi

	init(api: SpeedrunApi) {
		self.api = api
	}

	func execute() -> Observable<[Game]> {
		return api.rx
			.get(
				"games"
			).map({ data -> [Game] in
				guard
					let json = data as? [String: Any],
					let gamesJSON = json["data"] as? [[String: Any]]
					else {
						throw FetchGamesInteractorError.invalidResponse
				}
				return gamesJSON.compactMap ({ try? Game(fromDictionary: $0) })
			})
	}
}

