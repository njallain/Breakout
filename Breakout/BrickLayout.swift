//
//  BrickLayout.swift
//  Breakout
//
//  Created by Neil Allain on 9/1/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 Handles positioning all the bricks
*/
struct BrickLayout {
	let rowsPerSide: Int
	let columns: Int
	let brickSize: CGSize
	let brickSizeWithBorder: CGSize
	let brickMidpoint: CGPoint

	init(sceneSize: CGSize) {
		self.init(sceneSize: sceneSize, rowsPerSide: 3, columns: 10, brickBorder: 1, heightRatio: 0.1)
	}
	/**
	 Creates the brick layout
	 - Parameter sceneSize: The full size of the scene
	 - Parameter rowsPerSide: The number of rows of bricks for each side
	 - Parameter columns: The number of columns of bricks
	 - Parameter brickBorder: The amount of empty border around a brick
	 - Parameter: heightRatio: The ratio of the full height of the
	 							brick grid to the height of the scene
	*/
	init(
		sceneSize: CGSize,
		rowsPerSide: Int,
		columns: Int,
		brickBorder: CGFloat,
		heightRatio: CGFloat) {
		self.rowsPerSide = rowsPerSide
		self.columns = columns
		let sideHeight = sceneSize.height / 2
		let stackHeight = sideHeight * heightRatio
		let rowHeight = stackHeight / CGFloat(rowsPerSide)
		let columnWidth = sceneSize.width / CGFloat(columns)
		brickSizeWithBorder = CGSize(width: columnWidth, height: rowHeight)
		brickSize = CGSize(width: columnWidth - brickBorder, height: rowHeight - brickBorder)
		brickMidpoint = CGPoint(x: columnWidth / 2, y: rowHeight / 2)
	}

	func brickBody(row: Int, column: Int, side: Side) -> Body {
		let location = CGPoint(
			x: brickSizeWithBorder.width * CGFloat(column) + brickMidpoint.x,
			y: (brickSizeWithBorder.height * CGFloat(row) + brickMidpoint.y) * side.verticalMultipler )
		return Body(position: location, size: brickSize)
	}
}
