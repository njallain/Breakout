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
// swiftlint:disable identifier_name
enum Move {
	case none
	case moveTo(point: CGPoint)
	case moveToSide(x: CGFloat)
	case moveBy(velocity: CGVector)

	func moved(point: CGPoint, timeDelta: TimeInterval) -> CGPoint {
		switch self {
		case .none:
			return point
		case .moveTo(let newPoint):
			return newPoint
		case .moveToSide(let x):
			return CGPoint(x: x, y: point.y)
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
		case .none:
			return .zero
		case .moveTo(let newPoint):
			return CGVector(dx: newPoint.x - previousPosition.x, dy: newPoint.y - previousPosition.y)
		case .moveToSide(let x):
			return CGVector(dx: x - previousPosition.x, dy: 0)
		case .moveBy(let velocity):
			return velocity
		}
	}
}
// swiftlint:enable identifier_name

protocol MovableComponents {
	associatedtype MovableContainerType: ComponentContainer where MovableContainerType.ComponentType == Movable
	var movables: MovableContainerType {get}
}
