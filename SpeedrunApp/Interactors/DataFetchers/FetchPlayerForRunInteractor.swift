//
//  FetchPlayersForRunInteractor.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//
import UIKit
import RxSwift

protocol FetchPlayerForRun: class {
	func execute( for userID: String ) -> Observable<Player>
}

enum FetchPlayerForRunInteractorError: Error {
	case invalidResponse
}

class FetchPlayerForRunInteractor: FetchPlayerForRun {

	static var withDefaultApi: FetchPlayerForRunInteractor {
		return FetchPlayerForRunInteractor (api: SpeedrunApi.shared)
	}

	let api: SpeedrunApi

	init(api: SpeedrunApi) {
		self.api = api
	}

	func execute( for userID: String ) -> Observable<Player> {
		return api.rx
			.get(
				"users/\(userID)"
			).map({ data -> Player in
				guard
					let json = data as? [String: Any],
					let playerJSON = json["data"] as? [String: Any]
					else {
						throw FetchPlayerForRunInteractorError.invalidResponse
				}
				return try Player(fromDictionary: playerJSON)
			})
	}
}

