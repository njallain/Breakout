//
//  Movable.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftECS

/**
	Move a point by various strategies
*/
enum Move {
	case moveTo(point: CGPoint)
	case moveBy(velocity: CGVector)

	func moved(point: CGPoint, timeDelta: TimeInterval) -> CGPoint {
		switch self {
		case .moveTo(let newPoint):
			return newPoint
		case .moveBy(let velocity):
			return CGPoint(x: point.x + velocity.dx*CGFloat(timeDelta), y: point.y + velocity.dy*CGFloat(timeDelta))
		}

	}
}

/**
	Anything that needs to move in the game (the ball, the paddles)
*/
struct Movable: Component {
	var move: Move
	var previousPosition: CGPoint

	var velocity: CGVector {
		switch move {
		case .moveTo(let newPoint):
			return CGVector(dx: newPoint.x - previousPosition.x, dy: newPoint.y - previousPosition.y)
		case .moveBy(let velocity):
			return velocity
		}
	}
}

protocol MovableComponents {
	associatedtype MovableContainerType: ComponentContainer where MovableContainerType.ComponentType == Movable
	var movables: MovableContainerType {get}
}
