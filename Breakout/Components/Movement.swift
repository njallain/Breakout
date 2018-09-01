//
//  Movement.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics

/**
	Move a point by various strategies
*/
enum Move {
	case moveTo(point: CGPoint)
	case moveBy(velocity: CGVector)

	func moved(point: CGPoint) -> CGPoint {
		switch self {
		case .moveTo(let newPoint):
			return newPoint
		case .moveBy(let velocity):
			return CGPoint(x: point.x + velocity.dx, y: point.y + velocity.dy)
		}
	}
}

/**
	Anything that needs to move in the game (the ball, the paddles)
*/
struct Movement: Component {
	var move: Move
	var previousPosition: CGPoint
}

protocol MovementComponents {
	associatedtype MovementContainerType: ComponentContainer where MovementContainerType.ComponentType == Movement
	var movements: MovementContainerType {get}
}
