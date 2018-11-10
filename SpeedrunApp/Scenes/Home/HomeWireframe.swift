//
//  HomeWireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

protocol HomeNavigation: class {
	func presentGameDetail(game: Game)
}

class HomeWireframe: ObservableViewWireframe<HomePresenter> {
	let homePresenter : HomePresenter

	required init(navigation: Navigation, state: AppState ) {
		let view = HomeViewController()
		homePresenter = HomePresenter(
			state: state,
			view: view,
			eventsEmitter: view
		)

		super.init(navigation: navigation, presenter: homePresenter)

		viewController = view
		homePresenter.navigation = self
	}

	required init(navigation: Navigation) {
		fatalError("init(navigation:) has not been implemented")
	}

	override func createNavigationController () throws -> BaseNavigationController {
		guard navigationController == nil else { return navigationController! }
		guard let selfVC = viewController else { throw WireframePresentationError.nilSelfViewController }

		return BaseNavigationController.withNavigationBar(rootViewController: selfVC)
	}
}

extension HomeWireframe: HomeNavigation {
	func presentGameDetail(game: Game) {
		let gameDetailWireframe = GameDetailWireframe (
			navigation: navigation,
			game: game
		)
		try? gameDetailWireframe.push(inWireframe: self)
	}
}
