//
//  Body.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics

/**
	A physical body in the game that may be collided with
*/
struct Body: Component {
	var location: CGPoint
	var size: CGSize
}

protocol BodyComponents {
	associatedtype BodyContainerType: ComponentContainer where BodyContainerType.ComponentType == Body
	var bodies: BodyContainerType {get}
}
