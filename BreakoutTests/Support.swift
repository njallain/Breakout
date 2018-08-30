//
//  Support.swift
//  Solar Wind Tests
//
//  Created by Neil Allain on 7/26/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics
@testable import Solar_Wind

struct Tagged: Component, Equatable {
	let tag: String
}

struct Numbered: Component, Equatable {
	let num: Int
}

protocol ApproximateEquatable {
	static func ~= (lhs: Self, rhs: Self) -> Bool
}

extension CGFloat: ApproximateEquatable {
	static func ~= (lhs: CGFloat, rhs: CGFloat) -> Bool {
		let epsilon = CGFloat(0.001)
		return abs(lhs - rhs) < epsilon
	}

}

extension CGVector: ApproximateEquatable {
	static func ~= (lhs: CGVector, rhs: CGVector) -> Bool {
		return (lhs.dx ~= rhs.dx) && (lhs.dy ~= rhs.dy)
	}
}
extension ComputedVector: ApproximateEquatable {
	static func ~= (lhs: ComputedVector, rhs: ComputedVector) -> Bool {
		return (lhs.x ~= rhs.x) && (lhs.y ~= rhs.y)
	}
}
extension CGPoint: ApproximateEquatable {
	static func ~= (lhs: CGPoint, rhs: CGPoint) -> Bool {
		return (lhs.x ~= rhs.x) && (lhs.y ~= rhs.y)
	}
}

extension Angle: ApproximateEquatable {
	static func ~= (lhs: Angle, rhs: Angle) -> Bool {
		return lhs.radians ~= rhs.radians
	}
}
