//
//  GameViewController.swift
//  Breakout
//
//  Created by Neil Allain on 8/29/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let skView = self.view as? SKView else {
			return
		}
		// Load the SKScene from 'GameScene.sks'
		let scene = GameScene(size: skView.bounds.size)
		// Present the scene
		skView.presentScene(scene)

		skView.ignoresSiblingOrder = true

		skView.showsFPS = true
		skView.showsNodeCount = true
	}

	override var shouldAutorotate: Bool {
		return true
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}
