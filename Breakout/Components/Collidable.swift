//
//  Collidable.swift
//  Breakout
//
//  Created by Neil Allain on 9/2/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation

/**
 The CollisionCheck component is just an indicator that the entity needs
 to be checked against all Collidables for collisions.
 In this case, only the balls will have this component. So the collisions
 that will be checked are:
 - ball vs brick
 - ball vs paddle
 - ball vs ball
 - ball vs border
*/
struct CollisionCheck: Component {

}

protocol CollisionCheckComponents {
	associatedtype CollisionCheckContainerType: ComponentContainer
		where CollisionCheckContainerType.ComponentType == CollisionCheck
	var collisionChecks: CollisionCheckContainerType {get}
}

/**
 Any component that can be collided into will have this component.
 It will describe how this entity reacts to a collision.
 - Rebound
 - Inert
*/
enum Collidable: Component {
	case rebound
	case inert
	case changeSide
}

protocol CollidableComponents {
	associatedtype CollidableContainerType: ComponentContainer
		where CollidableContainerType.ComponentType == Collidable
	var collidables: CollidableContainerType {get}
}
