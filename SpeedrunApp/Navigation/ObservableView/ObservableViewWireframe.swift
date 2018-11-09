//
//  ObservableViewWireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

// Base Wireframe using with a viewController and a presenter.
// The particularity of this class is that the presenter is set as the views "observer"
class ObservableViewWireframe<P: ObserverPresenter>: Wireframe {
	let presenter: P
	
	override var viewController: UIViewController? {
		didSet {
			if let viewController = viewController as? ObservableViewController {
				viewController.viewObserver = self.presenter
			}
		}
	}
	
	init(navigation: Navigation, presenter: P) {
		self.presenter = presenter
		super.init(navigation: navigation)
	}
	
	required init(navigation: Navigation) {
		fatalError("init(navigation:) has not been implemented")
	}
}
