//
//  AgentSystem.swift
//  Breakout
//
//  Created by Neil Allain on 9/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SwiftECS

/**
 The agent system depends on the following components
 - Agent: determines which entities are controlled by an agent and the capabilities of the agent
 - Movable: the agent needs to be able to move the paddle and know where the ball is moving to.
 - Bodies: the agent needs to know the location of the balls
 - CollisionCheck: collision check components are the only things that are tested by Collidable component (the balls)
*/
protocol AgentScene: EntityScene, AgentComponents, MovableComponents, BodyComponents, CollisionCheckComponents {
}

/**
 All
*/
class AgentSystem<SceneType: AgentScene>: System {
	func update<SceneType: AgentScene>(scene: SceneType, timeDelta: TimeInterval) {
//		scene.agents.forEach(with: scene.movables, scene.bodies) { entity, agent, movable, body in
//			var updatedMovable = movable
//			guard let (ballPos, ballVelocity) = findBallToTrack(scene: scene, body: body) else { return }
//
//		}
	}

	private func findBallToTrack<SceneType: AgentScene>(scene: SceneType, body: Body) -> (CGPoint, CGVector)? {
		let ballMovements = scene.collisionChecks.entities.compactMap { ballEntity, _ in
			return ballEntity.get(components: scene.bodies, scene.movables)
		}
		let dangerousBalls = ballMovements.filter {
			let (ballBody, movable) = $0
			// return balls that are on the same side as the paddle and moving towards the paddle
			return body.position.y.sign == movable.velocity.dy.sign &&
				body.position.y.sign == ballBody.position.y.sign
		}
		// order by their proximity and return the first
		let ordered = dangerousBalls.sorted { lhs, rhs in
			return abs(lhs.0.position.y) > abs(rhs.0.position.y)
		}
		guard let first = ordered.first else { return nil }
		return (first.0.position, first.1.velocity)
	}
}
