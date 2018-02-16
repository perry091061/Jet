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
    let missleName = "missle"
    let asteroidName = "asteroid"
    var lastUpdateTime : TimeInterval = 0
    var lastShotFired  : TimeInterval = 0
    var shipTouch : Set<UITouch>?
    
    override func didMove(to view: SKView) {
        let texture = SKTexture(imageNamed: "background")
        let background = SKSpriteNode(texture: texture, color: SKColor.clear, size:CGSize(width: self.size.width, height: self.size.height))
        background.position = CGPoint(x:self.frame.size.width / 2,y:self.frame.size.height / 2)
        background.zPosition = -1
        self.addChild(background)
        
        //self.backgroundColor = SKColor.red
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shipTouch = nil
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
            
            if (currentTime - self.lastShotFired > 0.5)
            {
                self.shoot()
                self.lastShotFired = currentTime
             }
             
        }
        if arc4random_uniform(1000) <= 15
        {
            dropAsteroid()
        }
        checkCollisions()
        
        self.lastUpdateTime = currentTime
    }
    
    func checkCollisions()
    {
        var missle = self.childNode(withName: missleName)
        self.enumerateChildNodes(withName: asteroidName, using: {(object, stop) in
            
            if let missle = missle, missle.intersects(object)
            
            {
                self.shipTouch = nil
                missle.removeFromParent()
                object.removeFromParent()
            }
            
        })
    }
    
    func dropAsteroid()
    {
        let sideSize:CGFloat =  15.0  +  CGFloat(arc4random_uniform(30))
        let maxX:CGFloat = self.size.width
        let quarterX:CGFloat = maxX / 4
        let half  = UInt32(maxX +  quarterX * 2)
        
        let startX: CGFloat = CGFloat(arc4random_uniform(half)) - quarterX
        let startY: CGFloat = self.size.height + sideSize
        let endX  = arc4random_uniform(UInt32(maxX));
        let endY  = 0 - sideSize
        let random = arc4random_uniform(21) + 1
        
        let num = random < 10 ? "0\(random)" : "\(random)"
        
        let asteroid = SKSpriteNode(imageNamed: "asteroids_demo_\(num)")
        asteroid.name = asteroidName
        asteroid.zPosition = 1
        self.addChild(asteroid)
        asteroid.position = CGPoint(x:startX,y:startY)
        
        
        let move = SKAction.move(to: CGPoint(x:CGFloat(endX),y:CGFloat(endY)), duration: Double(3 + arc4random_uniform(4)))
        let remove = SKAction.removeFromParent()
        let action = SKAction.sequence([move,remove])
        let spin = SKAction.rotate(byAngle: 3, duration: Double(arc4random_uniform(2) + 1))
        let spinForever = SKAction.repeatForever(spin)
        let sequence = SKAction.sequence([action,spinForever])
        asteroid.run(sequence)
        
    }
    
    
    func shoot()
    {
         let ship = self.childNode(withName: shipName)!
         let missle = SKSpriteNode(imageNamed: missleName)
         missle.name = "missle"
         missle.scale(to: CGSize(width:40,height:40))
         missle.position = ship.position
         missle.position.y += missle.size.height / 2
         self.addChild(missle)
         let move = SKAction.moveBy(x: 0, y: self.size.height, duration: 0.5)
         let remove = SKAction.removeFromParent()
         let action = SKAction.sequence([move,remove])
        
         missle.run(action)
        
        
        
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
