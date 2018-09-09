//
//  BrickLayoutTests.swift
//  BreakoutTests
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import XCTest
@testable import Breakout

class SceneLayoutTests: XCTestCase {

	func testSceneLayoutInit() {
		assertAlmostEqual(CGFloat(300) * 0.25/2, layout.brickSizeWithBorder.height)
		assertAlmostEqual(CGFloat(200) / 10, layout.brickSizeWithBorder.width)
		assertAlmostEqual(CGFloat(300) * 0.25/2, layout.brickSize.height + 2)
		assertAlmostEqual(CGFloat(200) / 10, layout.brickSize.width + 2)
		assertAlmostEqual(90, layout.touchAreaHeight)
	}

	func testLayoutBrick() {
		let body = layout.brickBody(row: 2, column: 3, side: .playerOne)
		assertAlmostEqual(layout.brickSizeWithBorder.width * 3 + layout.brickMidpoint.x, body.position.x)
		assertAlmostEqual(-(layout.brickSizeWithBorder.height * 2 + layout.brickMidpoint.y), body.position.y)
		assertAlmostEqual(layout.brickSize, body.size)
	}

	func testBorderLayout() {
		let horizontalMiddle = layout.playAreaTop + (layout.borderWidth / 2)
		// bottom
		assertAlmostEqual(
			CGPoint(x: layout.midpoint.x, y: -horizontalMiddle),
			layout.borderBody(forSide: .bottom).position)
		assertAlmostEqual(
			CGSize(width: layout.sceneSize.width, height: layout.borderWidth),
			layout.borderBody(forSide: .bottom).size)

		// top
		assertAlmostEqual(
			CGPoint(x: layout.midpoint.x, y: horizontalMiddle),
			layout.borderBody(forSide: .top).position)
		assertAlmostEqual(
			CGSize(width: layout.sceneSize.width, height: layout.borderWidth),
			layout.borderBody(forSide: .top).size)

		// left
		assertAlmostEqual(
			CGPoint(x: -layout.borderWidth/2, y: 0),
			layout.borderBody(forSide: .left).position)
		assertAlmostEqual(
			CGSize(width: layout.borderWidth, height: layout.sceneSize.height),
			layout.borderBody(forSide: .left).size)

		// right
		assertAlmostEqual(
			CGPoint(x: layout.sceneSize.width + layout.borderWidth/2, y: 0),
			layout.borderBody(forSide: .right).position)
		assertAlmostEqual(
			CGSize(width: layout.borderWidth, height: layout.sceneSize.height),
			layout.borderBody(forSide: .right).size)
	}
	private let layout = SceneLayout(
			sceneSize: CGSize(width: 200, height: 600),
			rowsPerSide: 2,
			columns: 10,
			brickBorder: 2,
			brickHeightRatio: 0.25,
			touchAreaHeightRatio: 0.15)
}
