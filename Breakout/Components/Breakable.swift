//
//  Breakable.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

/**
	Any entity that can be broken
*/
struct Breakable: Component {
	/// The number of hits the breakable can take
	var health: Int
	/// The number of points the breakable is worth if the player on the same side breaks it
	let alignedScore: Int
	/// The number of points the breakable is worth if the player on the opposite side breaks it
	let opposingScore: Int
}

protocol BreakableComponents {
	associatedtype BreakableContainerType: ComponentContainer where BreakableContainerType.ComponentType == Breakable
	var breakables: BreakableContainerType {get}
}
