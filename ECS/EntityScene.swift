//
//  EntityScene.swift
//  Solar Wind iOS
//
//  Created by Neil Allain on 7/24/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayState {
	case running
	case paused

	var isPaused: Bool {
		switch self {
		case .running:
			return false
		case .paused:
			return true
		}
	}
}
protocol EntityScene {
	var builder: EntityBuilder {get}
	func update(_ currentTime: TimeInterval)
}

extension EntityScene {
	func apply(sideEffects: [SceneSideEffect]) {
		for sideEffect in sideEffects {
			sideEffect.apply(to: self)
		}
	}
}
enum SceneSideEffect {
	static let none = [SceneSideEffect]()

	case remove(entity: Entity, from: EntityContainer)
	case destroy(entity: Entity)

	func apply(to scene: EntityScene) {
		switch self {
		case .remove(let entity, let list):
			list.remove(entity: entity)
		case .destroy(let entity):
			scene.builder.destroy(entity: entity)
		}
	}
}
