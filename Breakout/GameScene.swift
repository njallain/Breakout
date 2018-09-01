//
//  GameScene.swift
//  Breakout
//
//  Created by Neil Allain on 8/29/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	let entityScene = BreakoutScene()
	override func didMove(to view: SKView) {
		self.anchorPoint = CGPoint(x: 0.0, y: 0.5)	// player one is on the negative side, player two is on the positive side
		self.scaleMode = .fill
		entityScene.setup(rootNode: self, sceneSize: self.size, numberOfPlayers: 0)
	}
	func touchDown(atPoint pos: CGPoint) {
	}
	func touchMoved(toPoint pos: CGPoint) {
	}
	func touchUp(atPoint pos: CGPoint) {
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
}
