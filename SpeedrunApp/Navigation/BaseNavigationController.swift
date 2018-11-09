//
//  BaseNavigationController.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//


import UIKit

class BaseNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupNavigationBar()
	}

	func setupNavigationBar() {
		self.navigationBar.isTranslucent = false
		
		removeBottomBorder()

		self.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.font: AppStyle.default.fonts.futura,
			NSAttributedString.Key.foregroundColor: AppStyle.default.colors.foreground
		]
	}

	override func pushViewController( _ viewController: UIViewController, animated: Bool ) {
		setUpBackNavigationButton()

		super.pushViewController( viewController, animated: animated )
	}

	override func popViewController(animated: Bool) -> UIViewController? {
		let poppedVC = super.popViewController(animated: animated)

		if let poppedVC = poppedVC as? WireframeViewController {
			poppedVC.wireframe?.viewControllerWasPopped()
		}

		return poppedVC
	}

	func setUpBackNavigationButton() {
		guard let navItem = self.topViewController?.navigationItem else { return }
		navItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navItem.backBarButtonItem?.tintColor = AppStyle.default.colors.foreground
	}
	
	func removeBottomBorder() {
		navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationBar.shadowImage = UIImage()
	}
}
