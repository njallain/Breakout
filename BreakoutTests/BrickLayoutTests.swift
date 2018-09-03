//
//  BrickLayoutTests.swift
//  BreakoutTests
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import XCTest
@testable import Breakout

class BrickLayoutTests: XCTestCase {

	func testBrickLayoutInit() {
		let layout = BrickLayout(
			sceneSize: CGSize(width: 200, height: 600),
			rowsPerSide: 2,
			columns: 10,
			brickBorder: 2,
			heightRatio: 0.25)

		assertAlmostEqual(CGFloat(300) * 0.25/2, layout.brickSizeWithBorder.height)
		assertAlmostEqual(CGFloat(200) / 10, layout.brickSizeWithBorder.width)
		assertAlmostEqual(CGFloat(300) * 0.25/2, layout.brickSize.height + 2)
		assertAlmostEqual(CGFloat(200) / 10, layout.brickSize.width + 2)
	}

	func testLayoutBrick() {
		let layout = BrickLayout(
			sceneSize: CGSize(width: 200, height: 600),
			rowsPerSide: 2,
			columns: 10,
			brickBorder: 2,
			heightRatio: 0.25)
		let body = layout.brickBody(row: 2, column: 3, side: .playerOne)
		assertAlmostEqual(layout.brickSizeWithBorder.width * 3 + layout.brickMidpoint.x, body.position.x)
		assertAlmostEqual(-(layout.brickSizeWithBorder.height * 2 + layout.brickMidpoint.y), body.position.y)
		assertAlmostEqual(layout.brickSize, body.size)
	}
}
