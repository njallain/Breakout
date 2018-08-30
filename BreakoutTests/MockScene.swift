//
//  MockScene.swift
//  Solar Wind Tests
//
//  Created by Neil Allain on 7/29/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
@testable import Breakout

//class MockScene : EntityScene, InputScene, PhysicsScene, LocomotiveComponents, MoveScene, ConditionComponents {
//	let builder = EntityBuilder()
//	let nodes = SparseComponentContainer<KitNode>()
//	let players = SparseComponentContainer<Player>()
//	let locomotives = SparseComponentContainer<Locomotive>()
//	let locations = SparseComponentContainer<Location>()
//	let physicsBodies = SparseComponentContainer<PhysicsBody>()
//	let modifiedPhysicsBodies = SparseComponentContainer<ModifiedComponent<PhysicsBodyModification>>()
//	let moves = SparseComponentContainer<Move>()
//	let conditions = SparseComponentContainer<Conditions>()
//	var physicsSettings = PhysicsSettings()
//	
//	
//	var lastUpdate: TimeInterval = 0
//	init() {
//		builder.register(lists: [nodes, players, locomotives, locations, physicsBodies])
//	}
//	func update(_ currentTime: TimeInterval) {
////		let delta = lastUpdate > 0 ? currentTime - lastUpdate : TimeInterval.oneFrame
////		inputScene.update(scene: self, timeDelta: delta)
////
//	}
//	
//}
