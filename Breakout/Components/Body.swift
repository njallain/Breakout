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

 /**
 Body description
*/
struct Body: Component {
	var position: CGPoint
	var size: CGSize

	var bounds: CGRect {
		let midY = size.height / 2
		let midX = size.width / 2
		return CGRect(origin: CGPoint(x: position.x - midX, y: position.y - midY), size: size)
	}
}

protocol BodyComponents {
	associatedtype BodyContainerType: ComponentContainer where BodyContainerType.ComponentType == Body
	var bodies: BodyContainerType {get}
}
