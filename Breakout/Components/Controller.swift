//
//  Controller.swift
//  Breakout
//
//  Created by Neil Allain on 9/12/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SwiftECS

struct Controller: Component {
	let entity: Entity
}

protocol ControllerComponents {
	associatedtype ControllerContainerType: ComponentContainer
		where ControllerContainerType.ComponentType == Controller
	var controllers: ControllerContainerType {get}
}
