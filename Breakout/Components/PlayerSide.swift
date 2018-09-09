//
//  Side.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftECS

/**
	Represents which side an entity is on.
	- paddle: the player that controls it
	- ball: the last player to hit the ball
	- bricks: the side that the brick is on (hitting the other player's bricks scores higher)
*/
enum PlayerSide: Component {
	case playerOne
	case playerTwo

	var verticalMultipler: CGFloat {
		switch self {
		case .playerOne:
			return -1
		case .playerTwo:
			return 1
		}
	}
}

protocol PlayerSideComponents {
	associatedtype SideContainerType: ComponentContainer where SideContainerType.ComponentType == PlayerSide
	var playerSides: SideContainerType {get}
}
