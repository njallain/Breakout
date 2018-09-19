//
//  CollisionSystem.swift
//  Breakout
//
//  Created by Neil Allain on 9/2/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftECS

/**
 The Collision system depends on the following components:
 - CollisionCheck: all entities that will be checked
 - Collidable: all entities that the checked object will be tested against
 - Body: size and position for determining the collision
 - Movable: if the collidable needs to rebound
 - Side: if the collision results in an an ownership change
*/
protocol CollisionScene: EntityScene,
	CollisionCheckComponents,
	CollidableComponents,
	BodyComponents,
	MovableComponents,
	PlayerSideComponents,
	BreakableComponents,
	GridPositionTags {
}

/**
 The collision system will test and resolve collisions between objects.
 This is one of the more complicated systems in the game.  Using SpriteKit
 physics would eliminate the need for all of this, but would also defeat the
 purpose of demonstrating ECS
*/
class CollisionSystem<SceneType: CollisionScene>: System {
	func update<SceneType: CollisionScene>(scene: SceneType, timeDelta: TimeInterval) {
		scene.collisionChecks.forEach(with: scene.collidables, scene.bodies) { entity, _, collidable, body in
			let gridPositions = scene.gridPositions.tags(forEntity: entity)
			let velocity = scene.movables.get(entity: entity)?.velocity ?? .zero
			let source = CollisionEntity(entity: entity, collidable: collidable, body: body, velocity: velocity)
			var collision: Collision?
			for targetEntity in scene.gridPositions.entities(withAnyTag: gridPositions) {
				guard
					targetEntity != entity,
					let targetCollidable = scene.collidables.get(entity: targetEntity),
					let targetBody = scene.bodies.get(entity: targetEntity) else { continue }
				let intersection = source.body.bounds.intersection(targetBody.bounds)
				if !intersection.isNull {
					// take the collision with more area
					if max(intersection.width, intersection.height) > collision?.size ?? 0 {
						let targetVelocity = scene.movables.get(entity: targetEntity)?.velocity ?? .zero
						let target = CollisionEntity(entity: targetEntity, collidable: targetCollidable,
							body: targetBody, velocity: targetVelocity)
						collision = Collision(source: source, target: target, intersection: intersection)
					}
				}
			}
			if let collision = collision {
				handleCollision(scene: scene, collision: collision, timeDelta: timeDelta)
			}
		}
	}

	private func handleCollision<SceneType: CollisionScene>(
		scene: SceneType,
		collision: Collision,
		timeDelta: TimeInterval) {
		resolveCollision(scene: scene, source: collision.source, target: collision.target,
			surface: collision.surface, timeDelta: timeDelta)
		resolveCollision(scene: scene, source: collision.target, target: collision.source,
			surface: collision.surface, timeDelta: timeDelta)
	}

	private func resolveCollision<SceneType: CollisionScene>(
		scene: SceneType,
		source: CollisionEntity,
		target: CollisionEntity,
		surface: CollisionSurface,
		timeDelta: TimeInterval) {
		switch source.collidable {
		case .rebound:
			guard var movable = scene.movables.get(entity: source.entity) else { return }
			movable.move = movable.move.reflected(surface: surface)
			scene.movables.update(entity: source.entity, component: movable)
			// move the body by the new vector to avoid the same collision next frame
			var updatedBody = source.body
			updatedBody.position = movable.move.moved(point: source.body.position, timeDelta: timeDelta)
			scene.bodies.update(entity: source.entity, component: updatedBody)
		case .changeSide:
			guard let mySide = scene.playerSides.get(entity: source.entity) else { return }
			scene.playerSides.update(entity: target.entity, component: mySide)
		case .inert:
			break
		}
	}
}

/**
 All the necessary pieces to determine if and where a collision will occur for one entity
 */
struct CollisionEntity {
	let entity: Entity
	let collidable: Collidable
	let body: Body
	let velocity: CGVector
}

struct Collision {
	let source: CollisionEntity
	let target: CollisionEntity
	let intersection: CGRect
	var surface: CollisionSurface { return intersection.width >= intersection.height ? .horizontal : .vertical }
	var size: CGFloat { return max(intersection.width, intersection.height) }
}
/**
 The data about a collision.
 In the case of these simplistic collisions all that is needed is
 whether the collision is against a vertical surface or a horizontal
*/
enum CollisionSurface {
	case vertical
	case horizontal

	func reflect(vector: CGVector) -> CGVector {
		switch self {
		case .vertical:
			return CGVector(dx: -vector.dx, dy: vector.dy)
		case .horizontal:
			return CGVector(dx: vector.dx, dy: -vector.dy)
		}
	}
}

/**
 Helpers to handle the collision for a moving entity
 */
extension Move {
	func reflected(surface: CollisionSurface) -> Move {
		switch self {
		case .none, .moveTo, .moveToSide:
			return self
		case .moveBy(let velocity):
			return .moveBy(velocity: surface.reflect(vector: velocity))
		}
	}
}

/**
 Helpers to get the corners of a rect
*/
extension CGRect {
	var topLeft: CGPoint {
		return CGPoint(x: origin.x, y: origin.y + size.height)
	}
	var topRight: CGPoint {
		return CGPoint(x: origin.x + size.width, y: origin.y + size.height)
	}
	var bottomLeft: CGPoint {
		return origin
	}
	var bottomRight: CGPoint {
		return CGPoint(x: origin.x + size.width, y: origin.y)
	}

}
