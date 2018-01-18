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
    var lastUpdateTime : TimeInterval = 0
    var shipTouch : Set<UITouch>?
    
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
        shipTouch = touches
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        shipTouch = touches
    }
    
    func calculateLocation(touches: Set<UITouch>) -> CGPoint
    {
        let touch = touches.first
        let location = touch?.location(in: self)
        return location ?? CGPoint(x:0,y:0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0
        {
            lastUpdateTime = currentTime
        }
        
        let timeDelta = currentTime - lastUpdateTime
        
        if let shipTouched = self.shipTouch
        {
            moveShipTowardPoint(point:calculateLocation(touches: shipTouched), timeDelta:timeDelta)
        }
        self.lastUpdateTime = currentTime
    }
    
    func moveShipTowardPoint(point:CGPoint, timeDelta:TimeInterval)
    {
        let shipSpeed:CGFloat = 130.0 // points per second
        let ship = self.childNode(withName: shipName)!
        let distanceLeft:CGFloat = sqrt(pow(ship.position.x - point.x, 2) +
            pow(ship.position.y - point.y, 2));
        if (distanceLeft > 4)
        {
            let distanceToTravel:CGFloat = CGFloat(timeDelta) * shipSpeed
            let angle:CGFloat = atan2(point.y - ship.position.y, point.x - ship.position.x)
            let yOffset:CGFloat = distanceToTravel * sin(angle);
            let xOffset:CGFloat = distanceToTravel * cos(angle);
            ship.position = CGPoint(x:ship.position.x + xOffset,
                                    y:ship.position.y + yOffset);
        }
    }
}
