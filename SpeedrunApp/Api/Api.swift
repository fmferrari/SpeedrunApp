//
//  Api.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Alamofire

typealias ApiMethod = Alamofire.HTTPMethod

// This is mostly a wrapper for Alamofire requests, just to tidy up things
class Api {
	let baseURL: URL
	
	init( baseURL: URL ) {
		self.baseURL = baseURL
	}

	// REQUESTS
	func request( _ method: ApiMethod,
					  path: String,
					  parameters: [String: AnyObject]? = nil,
					  encoding: ParameterEncoding = URLEncoding.default,
					  headers: [String: String]? = nil,
					  completion: @escaping (DataResponse<Any>) -> Void
	){
		Alamofire.request(
			urlForPath( path ).absoluteString,
			method: method,
			parameters: parameters,
			encoding: encoding,
			headers: headers
		).validate().responseJSON( completionHandler: completion )
	}

	func get(
		_ path: String,
		parameters: [String: AnyObject]? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: [String: String]? = nil,
		completion: @escaping (DataResponse<Any>) -> Void
	){
		return request(
			.get,
			path: path,
			parameters: parameters,
			encoding: encoding,
			headers: headers,
			completion: completion
		)
	}

	func urlForPath( _ path: String ) -> URL {
		return baseURL.appendingPathComponent( path )
	}
}

// MARK: Equatable
extension Api: Equatable {}

func ==(lhs: Api, rhs: Api) -> Bool {
	return lhs.baseURL == rhs.baseURL
}

