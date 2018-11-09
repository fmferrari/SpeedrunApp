//
//  FetchSpeedrunsInteractor.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit
import RxSwift

protocol FetchSpeedruns: class {
	func execute() -> Observable<[Speedrun]>
}

enum FetchSpeedrunsInteractorError: Error {
	case invalidResponse
}

class FetchSpeedrunsInteractor: FetchSpeedruns {

	static var withDefaultApi: FetchSpeedrunsInteractor {
		return FetchSpeedrunsInteractor (api: SpeedrunApi.shared)
	}

	let api: SpeedrunApi

	init(api: SpeedrunApi) {
		self.api = api
	}

	func execute() -> Observable<[Speedrun]> {
		return api.rx
			.get(
				"games"
			).map({ data -> [Speedrun] in
				guard
					let json = data as? [String: Any],
					let speedrunsJSON = json["data"] as? [[String: Any]]
					else {
						throw FetchSpeedrunsInteractorError.invalidResponse
				}
				return speedrunsJSON.compactMap ({ try? Speedrun(fromDictionary: $0) })
			})
	}
}

