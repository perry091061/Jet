//
//  GameScene.swift
//  Jet
//
//  Created by Perry Davies on 18/01/2018.
//  Copyright © 2018 Perry Davies. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var shipName: String = "F22-Jet"
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.red
        let ship : SKSpriteNode = SKSpriteNode(imageNamed: shipName)
        let x = self.frame.size.width / 2
        let y = self.frame.size.height / 2
        ship.name = shipName
        //ship.zRotation = CGFloat(180 * Double.pi / 180  )
        ship.position = CGPoint(x: x, y: y)
        self.addChild(ship)
        ship.scale(to: CGSize(width: 80, height: 80))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        var ship = self.childNode(withName: shipName)
        ship?.position = location ?? CGPoint(x:100,y:100)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
