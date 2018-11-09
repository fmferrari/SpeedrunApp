//
//  RxApi.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import RxSwift
import Alamofire

// This is a wrapper to make my Api class reactive, so i can subscribe to requests and get
// the responses as observables
class RxApi {
	let api: Api

	init (api: Api) {
		self.api = api
	}

	open func request( _ method: ApiMethod, path: String, parameters: [String: AnyObject]? = nil,
							 encoding: ParameterEncoding = URLEncoding.default,
							 headers: [String: String]? = nil) -> Observable<Any>
	{
		return Observable.create { observer in
			self.api
				.request(method, path: path, parameters: parameters, encoding: encoding, headers: headers)
					{ response in
						switch (response.result) {
						case .success(let data):
							observer.onNext(data)
							observer.on(.completed)
						case .failure(let error):
							observer.onError(error)
						}
					}

			return Disposables.create()
		}
	}

	open func get(
		_ path: String,
		parameters: [String: AnyObject]? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: [String: String]? = nil) -> Observable<Any>
	{
		return request( .get, path: path, parameters: parameters, encoding: encoding, headers: headers)
	}
}

extension Api {
	var rx: RxApi { get {
		return RxApi (api: self)
		}
	}
}
