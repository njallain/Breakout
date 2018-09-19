//
//  Agent.swift
//  Breakout
//
//  Created by Neil Allain on 9/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SwiftECS

/**
 Used to indicate an entity controlled by an agent
*/
struct Agent: Component {
	/// The maximum speed the agent can move the paddle in a second
	let speed: CGFloat
}

protocol AgentComponents {
	associatedtype AgentContainerType: ComponentContainer
		where AgentContainerType.ComponentType == Agent
	var agents: AgentContainerType {get}
}
