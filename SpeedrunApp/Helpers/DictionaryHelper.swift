//
//  DictionaryHelper.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

enum DictionaryError: Error {
	case keyNotFound
}

enum ParseErrors: Error {
	case invalidResourcePath
	case invalidDictionary
}


extension Dictionary {
	func valueOf<T>( _ key : Key ) throws -> T {
		guard let value : T = self[ key ] as? T else
		{
			throw DictionaryError.keyNotFound
		}
		return value
	}

}

extension Dictionary {
	func doubleOf (key: Key) throws -> Double {
		if let double: Double = try? self.valueOf(key) {
			return double
		}

		if let int: Int = try? self.valueOf(key) {
			return Double (int)
		}

		throw ParseErrors.invalidDictionary
	}
}

extension Dictionary {
	func urlValueOf(_ key: Key) throws -> URL {
		guard let urlString: String = try? self.valueOf(key),
			let url = URL(string: urlString) else
		{
			throw DictionaryError.keyNotFound
		}

		return url
	}
}

