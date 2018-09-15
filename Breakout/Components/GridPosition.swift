//
//  GridPosition.swift
//  Breakout
//
//  Created by Neil Allain on 9/15/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SwiftECS

// swiftlint:disable identifier_name
struct GridPosition: EntityTag {
	let x: Int
	let y: Int
}
// swiftlint:enable identifier_name

protocol GridPositionTags {
	associatedtype GridPositionContainer: EntityTagContainer where GridPositionContainer.TagType == GridPosition
	var gridPositions: GridPositionContainer {get}
	var layout: SceneLayout {get}
}
