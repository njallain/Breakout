//
//  BreakoutScene.swift
//  Breakout
//
//  Created by Neil Allain on 8/30/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SpriteKit

/**
 This is essentally the same idea as an SKScene or SCNScene.
 In fact, it could just be rolled into the already existing GameScene class.
 However, to remove a bit of extra complexity associated with the GameScene
 its been separated
*/
class BreakoutScene: EntityScene, MovementScene, CollisionScene {
	let builder = EntityBuilder()
	weak var rootNode: SKNode?
	var sceneSize = CGSize.zero
	var brickLayout = BrickLayout(sceneSize: .zero)
	var lastUpdate = TimeInterval(0)

	// all components
	let nodes = DenseComponentContainer<SKNode>()
	let bodies = DenseComponentContainer<Body>()
	let sides = DenseComponentContainer<Side>()
	let breakables = DenseComponentContainer<Breakable>()
	let movables = SparseComponentContainer<Movable>()
	let collidables = DenseComponentContainer<Collidable>()
	let collisionChecks = SparseComponentContainer<CollisionCheck>()

	// all systems
	let movementSystem = MovementSystem<BreakoutScene>()
	let collisionSystem = CollisionSystem<BreakoutScene>()

	func setup(rootNode: SKNode, sceneSize: CGSize, numberOfPlayers: Int) {
		self.rootNode = rootNode
		self.sceneSize = sceneSize
		self.brickLayout = BrickLayout(sceneSize: sceneSize)

		// make sure our state is reset
		builder.destroyAll()
		builder.unregisterAll()

		// register all containers
		builder.register(containers: [nodes, bodies])

		// setup all the entiies
		setupBricks()
		setupBorders()
		setupBalls()

		// make sure all sprites are positioned correctly
		updateSprites()
	}

	func update(_ currentTime: TimeInterval) {
		// if this is the first update, then just assume it's 1/60 of a second
		//let timeDelta = lastUpdate > 0 ? currentTime - lastUpdate : TimeInterval(1.0/60.0)
		// for debugging
		let timeDelta = TimeInterval(1.0/60.0)

		defer { lastUpdate = currentTime }
		movementSystem.update(scene: self, timeDelta: timeDelta)
		collisionSystem.update(scene: self, timeDelta: timeDelta)
		// sync all spritekit nodes with bodies in the ECS
		updateSprites()

	}

	private func updateSprites() {
		nodes.forEach(with: bodies) { _, sprite, body in
			sprite.position = body.position
		}
	}
}

/**
 Setup functions for the scene
*/
extension BreakoutScene {
	private func setupBricks() {
		for side in [Side.playerOne, Side.playerTwo] {
			for row in 0 ..< brickLayout.rowsPerSide {
				for column in 0 ..< brickLayout.columns {
					let brickSprite = SKSpriteNode(color: side.brickColor, size: brickLayout.brickSize)
					brickSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
					builder.build(node: brickSprite, list: nodes)
						.add(bodies, brickLayout.brickBody(row: row, column: column, side: side))
						.add(sides, side)
						.add(breakables, Breakable(health: 2, alignedScore: 1, opposingScore: 2))
						.add(collidables, .inert)
					rootNode?.addChild(brickSprite)
				}
			}
		}
	}

	private func setupBalls() {
		let ballSize = CGSize(width: brickLayout.brickSize.height, height: brickLayout.brickSize.height)
		for side in [Side.playerOne, Side.playerTwo] {
			let ballSprite = SKSpriteNode(color: side.ballColor, size: ballSize)
			ballSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			let position = CGPoint(x: sceneSize.width/2, y: sceneSize.height/4 * side.verticalMultipler)
			let direction = CGVector(dx: 50, dy: 70 * side.verticalMultipler)
			builder.build(node: ballSprite, list: nodes)
				.add(bodies, Body(position: position, size: ballSize))
				.add(movables, Movable(move: .moveBy(velocity: direction), previousPosition: position))
				.add(sides, side)
				.add(collisionChecks, CollisionCheck())
				.add(collidables, .rebound)
			rootNode?.addChild(ballSprite)
		}
	}
	private func setupBorders() {
		let middle = sceneSize.width / 2
		let left = CGFloat(-10)
		let right = sceneSize.width + 10
		let top = (sceneSize.height/2) + 10
		let bottom = -top
		// left side
		buildBorder(position: CGPoint(x: left, y: 0), size: CGSize(width: 20, height: sceneSize.height))
		// right side
		buildBorder(position: CGPoint(x: right, y: 0), size: CGSize(width: 20, height: sceneSize.height))
		// top side
		buildBorder(position: CGPoint(x: middle, y: top), size: CGSize(width: sceneSize.width, height: 20))
		// bottom side
		buildBorder(position: CGPoint(x: middle, y: bottom), size: CGSize(width: sceneSize.width, height: 20))
	}

	private func buildBorder(position: CGPoint, size: CGSize) {
		builder.build()
			.add(bodies, Body(position: position, size: size))
			.add(collidables, .inert)
	}
}

/**
 Side specific values
*/
extension Side {
	var brickColor: SKColor {
		switch self {
		case.playerOne:
			return .blue
		case .playerTwo:
			return .red
		}
	}
	var ballColor: SKColor {
		return brickColor
	}
}
