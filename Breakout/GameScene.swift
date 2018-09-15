//
//  GameScene.swift
//  Breakout
//
//  Created by Neil Allain on 8/29/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftECS

class GameScene: SKScene {
	private let entityScene = BreakoutScene()
	private var draggingEntities = [UITouch: Entity]()
	override func didMove(to view: SKView) {
		self.anchorPoint = CGPoint(x: 0.0, y: 0.5)	// player one is on the negative side, player two is on the positive side
		self.scaleMode = .fill
		entityScene.setup(rootNode: self, sceneSize: self.size, numberOfPlayers: 1)
	}
	func touchDown(atPoint pos: CGPoint) {
	}
	func touchMoved(toPoint pos: CGPoint) {
	}
	func touchUp(atPoint pos: CGPoint) {
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		entityScene.controllers.forEach(with: entityScene.nodes) { entity, _, node in
			guard let touch = touches.first(where: { node.contains($0.location(in: self)) }) else { return }
			draggingEntities[touch] = entity
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let touchPoint = touch.location(in: self)
			guard let entity = draggingEntities[touch] else {
				continue
			}
			entityScene.move(entity: entity, to: touchPoint)
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		touches.forEach { self.draggingEntities.removeValue(forKey: $0) }
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func update(_ currentTime: TimeInterval) {
		entityScene.update(currentTime)
	}
}
