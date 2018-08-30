//
//  EntitySceneTests.swift
//  Solar Wind Tests
//
//  Created by Neil Allain on 7/25/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import XCTest
@testable import Breakout

class EntitySceneTests: XCTestCase, EntityScene {
	var builder = EntityBuilder()
	var named = DenseComponentContainer<Named>()
	var tagged = DenseComponentContainer<Tagged>()

	override func setUp() {
		super.setUp()
		builder = EntityBuilder()
		named = DenseComponentContainer<Named>().register(with: builder)

	}

	override func tearDown() {
		super.tearDown()
	}

	func update(_ currentTime: TimeInterval) {

	}
}
