//
//  Controller.swift
//  Breakout
//
//  Created by Neil Allain on 9/12/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SwiftECS

/**
 Used to indicate the entity a player controls.
 In this case, the touch area below the paddle is used to control
 the paddle above it.
*/
struct PlayerController: Component {
	let entity: Entity
}

protocol PlayerControllerComponents {
	associatedtype PlayerControllerContainerType: ComponentContainer
		where PlayerControllerContainerType.ComponentType == PlayerController
	var controllers: PlayerControllerContainerType {get}
}
