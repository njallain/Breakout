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
	BreakableComponents {
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
			let velocity = scene.movables.get(entity: entity)?.velocity ?? .zero
			let source = CollisionEntity(entity: entity, collidable: collidable, body: body, velocity: velocity)
			scene.collidables.forEachUntil(with: scene.bodies) { targetEntity, targetCollidable, targetBody in
				if targetEntity != source.entity {
					let targetVelocity = scene.movables.get(entity: targetEntity)?.velocity ?? .zero
					let target = CollisionEntity(
						entity: targetEntity,
						collidable: targetCollidable,
						body: targetBody,
						velocity: targetVelocity)
					if handleCollision(scene: scene, source: source, target: target, timeDelta: timeDelta) != nil {
						return .break
					}
				}
				return .continue
			}
		}
	}

	private func handleCollision<SceneType: CollisionScene>(
		scene: SceneType,
		source: CollisionEntity,
		target: CollisionEntity,
		timeDelta: TimeInterval) -> Collision? {
		if let collision = collision(body: source.body, otherBody: target.body) {
			resolveCollision(scene: scene, source: source, target: target, collision: collision, timeDelta: timeDelta)
			resolveCollision(scene: scene, source: target, target: source, collision: collision, timeDelta: timeDelta)
			return collision
		}
		return nil
	}

	private func resolveCollision<SceneType: CollisionScene>(
		scene: SceneType,
		source: CollisionEntity,
		target: CollisionEntity,
		collision: Collision,
		timeDelta: TimeInterval) {
//		if let breakable = scene.breakables.get(source.entity) {
//			guard let mySide = scene.sides.get(entity: source.entity)
//		}
		switch source.collidable {
		case .rebound:
			guard var movable = scene.movables.get(entity: source.entity) else { return }
			movable.move = movable.move.reflected(collision: collision)
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

	/**
	 Determine if and where a collision occurrs between the 2 bodies
	 Since everything in this game is a rectangle, it just checks the
	 bounds of both bodies
	 */
	private func collision(body: Body, otherBody: Body) -> Collision? {
		let target = otherBody.bounds
		let source = body.bounds
		let topLeft = target.contains(source.topLeft)
		let bottomLeft = target.contains(source.bottomLeft)
		let topRight = target.contains(source.topRight)
		let bottomRight = target.contains(source.bottomRight)
		if topLeft {
			if topRight { return .horizontal }
			if bottomLeft { return .vertical }
			return Collision.largestOverlap(source.topLeft, target.bottomRight)
		}
		if topRight {
			// already checked topLeft & topRight
			if bottomRight { return .vertical }
			return Collision.largestOverlap(source.topRight, target.bottomLeft)
		}
		if bottomRight {
			if bottomLeft { return .horizontal }
			if topRight { return .vertical }
			return Collision.largestOverlap(source.bottomRight, target.topLeft)
		}
		if bottomLeft {
			// already checked bottomLeft & bottomRight
			if topLeft { return .vertical }
			return Collision.largestOverlap(source.bottomLeft, target.topRight)
		}
		return nil
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

/**
 The data about a collision.
 In the case of these simplistic collisions all that is needed is
 whether the collision is against a vertical surface or a horizontal
*/
enum Collision {
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
	static func largestOverlap(_ lhs: CGPoint, _ rhs: CGPoint) -> Collision {
		let xOverlap = abs(lhs.x - rhs.x)
		let yOverlap = abs(lhs.y - rhs.y)
		return xOverlap > yOverlap ? .horizontal : .vertical
	}
}

/**
 Helpers to handle the collision for a moving entity
 */
extension Move {
	func reflected(collision: Collision) -> Move {
		switch self {
		case .none, .moveTo, .moveToSide:
			return self
		case .moveBy(let velocity):
			return .moveBy(velocity: collision.reflect(vector: velocity))
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
