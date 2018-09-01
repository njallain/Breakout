//
//  BreakoutScene.swift
//  Breakout
//
//  Created by Neil Allain on 8/30/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SpriteKit

class BreakoutScene: EntityScene {
	let builder = EntityBuilder()
	var rootNode = SKNode()
	var sceneSize = CGSize.zero
	var brickLayout = BrickLayout(sceneSize: .zero)

	// all components
	let nodes = DenseComponentContainer<SKNode>()
	let bodies = DenseComponentContainer<Body>()

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
	}

	func update(_ currentTime: TimeInterval) {

		// sync all spritekit nodes with bodies in the ECS
		updateSprites()
	}

	private func setupBricks() {
		for side in [Side.playerOne, Side.playerTwo] {
			for row in 0 ..< brickLayout.rowsPerSide {
				for column in 0 ..< brickLayout.columns {
					let brickSprite = SKSpriteNode(color: .white, size: brickLayout.brickSize)
					brickSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
					builder.build(node: brickSprite, list: nodes)
						.add(bodies, brickLayout.brickBody(row: row, column: column, side: side))
					rootNode.addChild(brickSprite)
				}
			}
		}
		updateSprites()
	}

	private func updateSprites() {
		nodes.forEach(with: bodies) { _, sprite, body in
			sprite.position = body.location
		}
	}
}
