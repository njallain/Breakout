//
//  BreakoutScene.swift
//  Breakout
//
//  Created by Neil Allain on 8/30/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftECS

/**
 This is essentally the same idea as an SKScene or SCNScene.
 In fact, it could just be rolled into the already existing GameScene class.
 However, to remove a bit of extra complexity associated with the GameScene
 its been separated
*/
class BreakoutScene: EntityScene, MovementScene, CollisionScene, PlayerControllerComponents, GridPositionTags {
	let builder = EntityBuilder()
	weak var rootNode: SKNode?
	var sceneSize = CGSize.zero
	var layout = SceneLayout(sceneSize: .zero)
	var lastUpdate = TimeInterval(0)

	// all components
	let nodes = DenseComponentContainer<SKNode>()
	let bodies = DenseComponentContainer<Body>()
	let playerSides = DenseComponentContainer<PlayerSide>()
	let breakables = DenseComponentContainer<Breakable>()
	let movables = SparseComponentContainer<Movable>()
	let collidables = DenseComponentContainer<Collidable>()
	let collisionChecks = SparseComponentContainer<CollisionCheck>()
	let controllers = SparseComponentContainer<PlayerController>()
	let gridPositions = DenseTagContainer<GridPosition>()

	// all systems
	let movementSystem = MovementSystem<BreakoutScene>()
	let collisionSystem = CollisionSystem<BreakoutScene>()

	func setup(rootNode: SKNode, sceneSize: CGSize, numberOfPlayers: Int) {
		self.rootNode = rootNode
		self.sceneSize = sceneSize
		self.layout = SceneLayout(sceneSize: sceneSize)

		// make sure our state is reset
		builder.destroyAll()
		builder.unregisterAll()

		// register all containers
		builder.register(containers: [
			nodes, bodies, playerSides, breakables, movables, collidables, collisionChecks, controllers])

		// setup all the entiies
		setupBricks()
		setupBorders()
		setupBalls()
		setupPaddles(numberOfPlayers: numberOfPlayers)

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
		nodes.forEach(with: bodies) { entity, node, body in
			node.position = body.position
			if let playerSide = playerSides.get(entity: entity),
				let sprite = node as? SKSpriteNode {
				sprite.color = playerSide.ballColor
			}
		}
	}
}

/**
 Setup functions for the scene
*/
extension BreakoutScene {
	private func setupBricks() {
		for side in [PlayerSide.playerOne, PlayerSide.playerTwo] {
			for row in 0 ..< layout.rowsPerSide {
				for column in 0 ..< layout.columns {
					let brickSprite = SKSpriteNode(color: side.brickColor, size: layout.brickSize)
					brickSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
					let brickBody = layout.brickBody(row: row, column: column, side: side)
					let node = builder.build(node: brickSprite, list: nodes)
						.add(bodies, brickBody)
						.add(playerSides, side)
						.add(breakables, Breakable(health: 2, alignedScore: 1, opposingScore: 2))
						.add(collidables, .inert)
					gridPositions.set(tags: layout.gridPositions(for: brickBody.bounds), forEntity: node.entity)
					rootNode?.addChild(brickSprite)
				}
			}
		}
	}

	private func setupBalls() {
		let ballSize = CGSize(width: layout.brickSize.height, height: layout.brickSize.height)
		for side in [PlayerSide.playerOne, PlayerSide.playerTwo] {
			let ballSprite = SKSpriteNode(color: side.ballColor, size: ballSize)
			ballSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			let position = CGPoint(x: sceneSize.width/2, y: sceneSize.height/4 * side.verticalMultipler)
			let direction = CGVector(dx: 50, dy: 70 * side.verticalMultipler)
			builder.build(node: ballSprite, list: nodes)
				.add(bodies, Body(position: position, size: ballSize))
				.add(movables, Movable(move: .moveBy(velocity: direction), previousPosition: position))
				.add(playerSides, side)
				.add(collisionChecks, CollisionCheck())
				.add(collidables, .rebound)
			rootNode?.addChild(ballSprite)
		}
	}
	private func setupBorders() {
		buildBorder(side: .left)
		buildBorder(side: .right)
		buildBorder(side: .top)
		buildBorder(side: .bottom)
	}

	private func setupPaddles(numberOfPlayers: Int) {
		buildPaddle(side: .playerOne, isPlayer: numberOfPlayers >= 1)
		buildPaddle(side: .playerTwo, isPlayer: numberOfPlayers >= 2)
	}
	private func buildBorder(side: SceneSide) {
		let body = layout.borderBody(forSide: side)
		let entity = builder.build()
			.add(bodies, body)
			.add(collidables, .inert)
		gridPositions.set(tags: layout.gridPositions(for: body.bounds), forEntity: entity)
	  if let playerSide = side.playerSide {
			entity.add(collidables, .changeSide)
				.add(playerSides, playerSide.otherSide)
		} else {
			entity.add(collidables, .inert)
		}

		switch side {
		case .left, .right:
			break
		case .top, .bottom:
			let sprite = SKSpriteNode(color: .gray, size: CGSize(width: body.size.width, height: layout.borderVisualWidth))
			sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			sprite.position = side.borderVisualPosition(layout: layout)
			// the sprite isn't added to the entity.  if it is, the position would be adjusted
			// to have the same center as the entity body
			rootNode?.addChild(sprite)
		}
	}

	private func buildPaddle(side: PlayerSide, isPlayer: Bool) {
		let body = layout.paddleBody(forSide: side.sceneSide)
		let sprite = SKSpriteNode(color: side.paddleColor, size: body.size)
		sprite.position = body.position
		sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		let paddle = builder.build(node: sprite, list: nodes)
			.add(bodies, body)
			.add(playerSides, side)
			.add(collidables, .changeSide)
			.add(movables, Movable(move: .none, previousPosition: body.position))
		gridPositions.set(tags: layout.gridPositions(for: body.bounds), forEntity: paddle.entity)
		rootNode?.addChild(sprite)

		let touchBody = layout.touchBody(forSide: side.sceneSide)
		let touchSprite = SKSpriteNode(color: side.touchColor, size: touchBody.size)
		touchSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		let touchNode = builder.build(node: touchSprite, list: nodes)
			.add(bodies, touchBody)
			.add(movables, Movable(move: .none, previousPosition: touchBody.position))
		if isPlayer {
			touchNode.add(controllers, PlayerController(entity: paddle.entity))
		}
		rootNode?.addChild(touchSprite)
	}
}

/// Input extensions
extension BreakoutScene {
	func move(entity: Entity, to point: CGPoint) {
		guard let (controller, movable) = entity.get(components: controllers, movables),
			let paddleMovable = movables.get(entity: controller.entity) else { return }
		var updatedPaddle = paddleMovable
		var updatedController = movable
		updatedPaddle.move = .moveToSide(x: point.x)
		updatedController.move = .moveToSide(x: point.x)
		movables.update(entity: entity, component: updatedPaddle)
		movables.update(entity: controller.entity, component: updatedController)
	}
}
/**
 PlayerSide specific values
*/
extension PlayerSide {
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
	var paddleColor: SKColor {
		return brickColor
	}
	var touchColor: SKColor {
		return .gray
	}

	var sceneSide: SceneSide {
		switch self {
		case .playerOne:
			return .bottom
		case .playerTwo:
			return .top
		}
	}
}

extension SceneSide {
	var playerSide: PlayerSide? {
		switch self {
		case .left, .right:
			return nil
		case .top:
			return .playerTwo
		case .bottom:
			return .playerOne
		}
	}
}
