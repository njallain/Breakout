//
//  MovementSystem.swift
//  Breakout
//
//  Created by Neil Allain on 9/2/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

/**
 The movement system depends on the following components
 - Movables: determine how the entity moves
 - Bodies: the location of the entity
*/
protocol MovementScene: EntityScene, MovableComponents, BodyComponents {
}

/**
 Moves all of the components that need to be
*/
class MovementSystem<SceneType: MovementScene>: System {
	func update<SceneType: MovementScene>(scene: SceneType, timeDelta: TimeInterval) {
		scene.movables.forEach(with: scene.bodies) { entity, movable, body in
			var updatedMovable = movable
			var updatedBody = body
			updatedMovable.previousPosition = body.position
			updatedBody.position = movable.move.moved(point: updatedBody.position, timeDelta: timeDelta)
			scene.bodies.update(entity: entity, component: updatedBody)
			scene.movables.update(entity: entity, component: updatedMovable)
		}
	}
}
