//
//  FetchRunsInteractor.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit
import RxSwift

protocol FetchRuns: class {
	func execute( for gameID: String ) -> Observable<[Run]>
}

enum FetchRunsInteractorError: Error {
	case invalidResponse
}

class FetchRunsInteractor: FetchRuns {

	static var withDefaultApi: FetchRunsInteractor {
		return FetchRunsInteractor (api: SpeedrunApi.shared)
	}

	let api: SpeedrunApi

	init(api: SpeedrunApi) {
		self.api = api
	}

	func execute( for gameID: String ) -> Observable<[Run]> {
		let parameters = ["game" : gameID] as [String: AnyObject]
		return api.rx
			.get(
				"runs",
				parameters: parameters
			).map({ data -> [Run] in
				guard
					let json = data as? [String: Any],
					let runsJSON = json["data"] as? [[String: Any]]
					else {
						throw FetchRunsInteractorError.invalidResponse
				}
				return runsJSON.compactMap ({ try? Run(fromDictionary: $0) })
			})
	}
}

