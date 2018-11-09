//
//  Wireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

enum WireframeViewControllerError: Error {
	case viewControllerWithoutWireframe
}

enum WireframePresentationError : Error {
	case nilSelfViewController
	case nilOverViewController
	case notNavigationController
	case nilChildViewController
}

protocol ViewControllerWithWireframe {
	var wireframe: Wireframe? { get set }
}

class WireframeViewController : UIViewController, ViewControllerWithWireframe {
	weak var wireframe: Wireframe?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		wireframe?.viewControllerWillAppear()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		wireframe?.viewControllerDidDisappear()
	}
}

// This class is responsible of managing viewControllers displayed in its navigation window
class Wireframe {
	var viewController : UIViewController? {
		didSet {
			if var wireframeVC = viewController as? ViewControllerWithWireframe {
				wireframeVC.wireframe = self
			}
		}
	}
	var navigationController : BaseNavigationController? {
		return self.viewController?.navigationController as? BaseNavigationController
	}

	var navigation: Navigation
	var presenting : Wireframe? = nil
	weak var presentedBy : Wireframe? = nil

	required init(navigation: Navigation) {
		self.navigation = navigation
	}

	func setAsRootWireframe( inNavigation: Bool = false ) throws {
		guard let selfVC = self.viewController else {
			throw WireframePresentationError.nilSelfViewController
		}

		let vcToPresent = inNavigation ? try createNavigationController() : selfVC

		navigation.window.rootViewController = vcToPresent
		navigation.rootWireframe = self
	}

	// Push Navigation
	func push( inWireframe: Wireframe, animated: Bool = true ) throws {
		guard let inVC   = inWireframe.viewController?.navigationController else { throw WireframePresentationError.notNavigationController }
		guard let selfVC = self.viewController else { throw WireframePresentationError.nilSelfViewController }

		inVC.pushViewController( selfVC, animated: animated )

		inWireframe.presenting  = self
		self.presentedBy = inWireframe
	}
	
	func createNavigationController () throws -> BaseNavigationController {
		guard navigationController == nil else { return navigationController! }
		guard let selfVC = viewController else { throw WireframePresentationError.nilSelfViewController }
		
		return BaseNavigationController (rootViewController: selfVC)
	}

	private var isPoppingViewController: Bool = false

	func viewControllerWillAppear () {}

	func viewControllerDidDisappear () {
		if isPoppingViewController {
			self.presentedBy?.presenting = nil
			isPoppingViewController = false
		}
	}

	func viewControllerWasPopped () {
		isPoppingViewController = true
	}
}

extension Wireframe: Equatable {
	static func ==(lhs: Wireframe, rhs: Wireframe) -> Bool {
		return lhs.viewController == rhs.viewController
	}
}

extension Wireframe {
	func presentInformationPopup(
		title: String? = nil,
		message: String,
		animated: Bool = true,
		action: ( () -> Void)? = nil
		) {
		let alertVC = UIAlertController( title: title, message: message, preferredStyle: .alert )

		let okAction = UIAlertAction( title: "Ok", style: .default) { _ in action? () }
		alertVC.addAction(okAction)

		self.viewController?.present( alertVC, animated: animated, completion: nil )
	}
}

