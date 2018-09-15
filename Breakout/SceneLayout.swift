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
struct SceneLayout {
	// full size of the scene
	let sceneSize: CGSize
	// number of rows of bricks on each side
	let rowsPerSide: Int
	// number of columns of bricks
	let columns: Int
	// height of one side (including touch area)
	let sideHeight: CGFloat
	// size of a single brick
	let brickSize: CGSize
	// size of a single brick plus the border around it
	let brickSizeWithBorder: CGSize
	// the middle of a brick for positioning
	let brickMidpoint: CGPoint
	// the height of the touch area on each side
	let touchAreaHeight: CGFloat
	// the midpoint of the entire scene
	let midpoint: CGPoint
	let playAreaBottom: CGFloat
	let playAreaTop: CGFloat
	let borderWidth: CGFloat
	let borderVisualWidth: CGFloat
	let paddleSize: CGSize

	init(sceneSize: CGSize) {
		self.init(
			sceneSize: sceneSize,
			rowsPerSide: 3,
			columns: 10,
			brickBorder: 1,
			brickHeightRatio: 0.1,
			touchAreaHeightRatio: 0.1)
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
		brickHeightRatio: CGFloat,
		touchAreaHeightRatio: CGFloat) {
		self.sceneSize = sceneSize
		self.rowsPerSide = rowsPerSide
		self.columns = columns
		self.sideHeight = sceneSize.height / 2
		let stackHeight = sideHeight * brickHeightRatio
		let rowHeight = stackHeight / CGFloat(rowsPerSide)
		let columnWidth = sceneSize.width / CGFloat(columns)
		brickSizeWithBorder = CGSize(width: columnWidth, height: rowHeight)
		brickSize = CGSize(width: columnWidth - brickBorder, height: rowHeight - brickBorder)
		paddleSize = brickSize
		brickMidpoint = CGPoint(x: columnWidth / 2, y: rowHeight / 2)
		touchAreaHeight = sceneSize.height * touchAreaHeightRatio
		midpoint = CGPoint(x: sceneSize.width / 2, y: 0)
		playAreaTop = sideHeight - touchAreaHeight
		playAreaBottom = -playAreaTop
		borderWidth = 20
		borderVisualWidth = 5

	}

	func brickBody(row: Int, column: Int, side: PlayerSide) -> Body {
		let location = CGPoint(
			x: brickSizeWithBorder.width * CGFloat(column) + brickMidpoint.x,
			y: (brickSizeWithBorder.height * CGFloat(row) + brickMidpoint.y) * side.verticalMultipler )
		return Body(position: location, size: brickSize)
	}

	func borderBody(forSide side: SceneSide) -> Body {
		let position = CGPoint(x: side.borderBodyX(layout: self), y: side.borderBodyY(layout: self))
		let size = CGSize(width: side.borderBodyWidth(layout: self), height: side.borderBodyHeight(layout: self))
		return Body(position: position, size: size)
	}

	func paddleBody(forSide side: SceneSide) -> Body {
		let position = CGPoint(x: midpoint.x, y: side.paddleBodyY(layout: self))
		return Body(position: position, size: paddleSize)
	}
	func touchBody(forSide side: SceneSide) -> Body {
		let position = CGPoint(x: midpoint.x, y: side.touchBodyY(layout: self))
		let size = CGSize(width: paddleSize.width, height: touchAreaHeight)
		return Body(position: position, size: size)
	}

	func gridPosition(for point: CGPoint) -> GridPosition {
		return GridPosition(
			x: Int(floor(point.x / brickSizeWithBorder.width)),
			y: Int(floor(point.y / brickSizeWithBorder.height)))
	}
	func gridPositions(for rect: CGRect) -> Set<GridPosition> {
		let topRight = gridPosition(for: rect.topRight)
		let bottomLeft = gridPosition(for: rect.bottomLeft)
		var positions =  Set<GridPosition>()
		for gridX in bottomLeft.x...topRight.x {
			for gridY in bottomLeft.y...topRight.y {
				positions.insert(GridPosition(x: gridX, y: gridY))
			}
		}
		return positions
	}
}

enum SceneSide {
	case top
	case bottom
	case left
	case right
}

extension SceneSide {
	func borderBodyX(layout: SceneLayout) -> CGFloat {
		switch self {
		case .top, .bottom:
			return layout.midpoint.x
		case .left:
			return -(layout.borderWidth/2)
		case .right:
			return layout.sceneSize.width + (layout.borderWidth/2)
		}
	}
	func borderBodyY(layout: SceneLayout) -> CGFloat {
		switch self {
		case .top:
			return layout.playAreaTop + (layout.borderWidth/2)
		case .bottom:
			return layout.playAreaBottom - (layout.borderWidth/2)
		case .left, .right:
			return 0
		}
	}
	func borderBodyWidth(layout: SceneLayout) -> CGFloat {
		switch self {
		case .top, .bottom:
			return layout.sceneSize.width
		case .left, .right:
			return layout.borderWidth
		}
	}
	func borderBodyHeight(layout: SceneLayout) -> CGFloat {
		switch self {
		case .top, .bottom:
			return layout.borderWidth
		case .left, .right:
			return layout.sceneSize.height
		}
	}

	func borderVisualPosition(layout: SceneLayout) -> CGPoint {
		switch self {
		case .left, .right:
			return .zero
		case .top:
			return CGPoint(x: layout.midpoint.x, y: layout.playAreaTop + layout.borderVisualWidth/2)
		case .bottom:
			return CGPoint(x: layout.midpoint.x, y: layout.playAreaBottom - layout.borderVisualWidth/2)
		}
	}

	func paddleBodyY(layout: SceneLayout) -> CGFloat {
		switch self {
		case .left, .right:
			return 0
		case .top:
			return layout.playAreaTop - (layout.paddleSize.height/2)
		case .bottom:
			return layout.playAreaBottom + (layout.paddleSize.height/2)
		}
	}
	func touchBodyY(layout: SceneLayout) -> CGFloat {
		switch self {
		case .left, .right:
			return 0
		case .top:
			return layout.playAreaTop + (layout.touchAreaHeight/2)
		case .bottom:
			return layout.playAreaBottom - (layout.touchAreaHeight/2)
		}
	}
}
