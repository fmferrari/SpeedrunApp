//
//  StubHelper.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

func contains (_ partial: String, method expectedMethod: String) -> (URLRequest) -> Bool {
	return { request in
		guard let url = request.url?.absoluteString, let method = request.httpMethod else { return false }
		return method == expectedMethod && url.contains(partial)
	}
}
