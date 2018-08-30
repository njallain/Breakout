//
//  NodeComponent.swift
//  Solar Wind iOS
//
//  Created by Neil Allain on 7/24/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import SpriteKit

typealias KitNode = SKNode

private var nodeEntityId = "entityId"
extension KitNode: Component {
	var associatedEntity: Entity? {
		get {
			guard let val = objc_getAssociatedObject(self, &nodeEntityId), let oid = val as? Int else {
				return nil
			}
			return Entity(id: oid)
		}
		set(newValue) {
			objc_setAssociatedObject(self, &nodeEntityId, newValue?.id, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
}

protocol NodeComponents {
	associatedtype NodeListType: ComponentContainer where NodeListType.ComponentType == KitNode
	var nodes: NodeListType {get}
}
struct EntityNode<NodeType: KitNode> {
	let entity: Entity
	let node: NodeType

	@discardableResult
	func add<ComponentListType: ComponentContainer>(
		_ list: ComponentListType,
		_ component: ComponentListType.ComponentType) -> EntityNode<NodeType> {
		list.update(entity: self.entity, component: component)
		return self
	}
}

extension EntityBuilder {
	@discardableResult
	func build<NodeType: KitNode, ComponentListType: ComponentContainer>(
		node: NodeType,
		list: ComponentListType) -> EntityNode<NodeType>
		where  ComponentListType.ComponentType == KitNode {
		let nodeBuilder = EntityNode(entity: self.build(), node: node)
		list.update(entity: nodeBuilder.entity, component: nodeBuilder.node)
		node.associatedEntity = nodeBuilder.entity
		return nodeBuilder
	}
}

//protocol NodeScene: EntityScene, NodeComponents, LocationComponents {
//
//}
//class NodeSystem<SceneType: NodeScene>: System {
//	func update<SceneType: NodeScene>(scene: SceneType, timeDelta: TimeInterval) {
//		scene.nodes.forEach(with: scene.locations) { _, node, location in
//			node.position = location.position
//			node.zRotation = location.rotation.radians
//		}
//	}
//}
