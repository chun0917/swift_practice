//
//  GameScene.swift
//  JumpKing
//
//  Created by 呂淳昇 on 2022/2/17.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene:SKScene,SKPhysicsContactDelegate{
    let background = SKSpriteNode(imageNamed: "Background_Clouds")
    let player = SKSpriteNode(imageNamed: "CharacterRight_Standing")
    let ground = SKSpriteNode(imageNamed: "LandPiece_DarkGreen")
    let gameOverLine = SKSpriteNode(color: .red, size: CGSize(width: 700, height: 10))
    let scoreLabel = SKLabelNode()
    let bestScoreLabel = SKLabelNode()
    let cam = SKCameraNode()
    let defaults = UserDefaults.standard
    var firstTouch = false
    var score = 0
    var bestScore = 0
    
    enum bitmasks: UInt32 {
        case player = 0b1
        case platform = 0b10
        case gameOverLine
    }
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
        self.anchorPoint = .zero
        
        physicsWorld.contactDelegate = self
        
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        ground.size = CGSize(width: UIScreen.main.bounds.width, height: 150)
        ground.position = CGPoint(x: size.width/2, y: -200)
        ground.zPosition = 5
        ground.setScale(1.5)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false //是否受所有施加於此物體的所有外力及衝量影響
        ground.physicsBody?.allowsRotation = false //是否受所有施加於此物體的角動力及衝量影響
        ground.physicsBody?.affectedByGravity = false //是否受重力（地心引力）影響
        addChild(ground)
        
        player.position = CGPoint(x: size.width/2, y: -50)
        player.zPosition = 10
        player.setScale(1)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.restitution = 1 //彈性係數
        player.physicsBody?.friction = 0 //摩擦係數
        player.physicsBody?.categoryBitMask = bitmasks.player.rawValue
        player.physicsBody?.collisionBitMask = 0 //碰撞
        player.physicsBody?.contactTestBitMask = bitmasks.platform.rawValue | bitmasks.gameOverLine.rawValue
        addChild(player)
        
        gameOverLine.alpha = 0
        gameOverLine.position = CGPoint(x: player.position.x, y: player.position.y - 200)
        gameOverLine.zPosition = 10
        gameOverLine.physicsBody = SKPhysicsBody(rectangleOf: gameOverLine.size)
        gameOverLine.physicsBody?.affectedByGravity = false
        gameOverLine.physicsBody?.allowsRotation = false
        gameOverLine.physicsBody?.categoryBitMask = bitmasks.gameOverLine.rawValue
        //gameOverLine.physicsBody?.collisionBitMask = 0
        gameOverLine.physicsBody?.contactTestBitMask = bitmasks.platform.rawValue | bitmasks.player.rawValue
        addChild(gameOverLine)
        
        scoreLabel.position.x = 100
        scoreLabel.zPosition = 20
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = .black
        scoreLabel.text = "Score : \(score)"
        addChild(scoreLabel)
        
        bestScore = defaults.integer(forKey: "best")
        bestScoreLabel.position.x = 670
        bestScoreLabel.zPosition = 20
        bestScoreLabel.fontName = "Chalkduster"
        bestScoreLabel.fontSize = 32
        bestScoreLabel.fontColor = .black
        bestScoreLabel.text = "Bestscore : \(bestScore)"
        addChild(bestScoreLabel)
        
        makePlatform()
        makePlatform2()
        makePlatform3()
        makePlatform4()
        makePlatform5()
        makePlatform6()
        cam.setScale(1)
        cam.position.x = player.position.x
        camera = cam
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.isDynamic = true
        if firstTouch == false {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        }
        firstTouch = true
    }
    override func update(_ currentTime: TimeInterval) {
        cam.position.y = player.position.y + 350
        background.position.y = player.position.y + 350
        if player.physicsBody!.velocity.dy > 0{
            gameOverLine.position.y = player.position.y - 600
        }
        scoreLabel.position.y = player.position.y + 850
        bestScoreLabel.position.y = player.position.y + 850
    }
    
    func makePlatform(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 140, highestValue: 300).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform2(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 350, highestValue: 550).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform3(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 600, highestValue: 800).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform4(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 850, highestValue: 1050).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform5(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 1100, highestValue: 1300).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }

    func makePlatform6(){
        let platform = SKSpriteNode(imageNamed: "BrokenLandPiece_Green")
        //platform.size = CGSize(width: 200, height: 50)
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 700).nextInt(), y: GKRandomDistribution(lowestValue: 1350, highestValue: 1550).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.setScale(1)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitmasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitmasks.player.rawValue
        addChild(platform)
    }
    
    func addScore(){
        score = score + 1
        scoreLabel.text = "Score : \(score)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            contactA = contact.bodyA //player
            contactB = contact.bodyB //platform
        } else{
            contactA = contact.bodyB//player
            contactB = contact.bodyA //platform
        }
        if contactA.categoryBitMask == bitmasks.platform.rawValue && contactB.categoryBitMask == bitmasks.gameOverLine.rawValue{
            contactA.node?.removeFromParent()
        }
        if contactA.categoryBitMask == bitmasks.player.rawValue && contactB.categoryBitMask == bitmasks.platform.rawValue{
            if player.physicsBody!.velocity.dy < 0{
                player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 1400)
                contactB.node?.removeFromParent()
                makePlatform5()
                makePlatform6()
                addScore()
            }
        }
        if contactA.categoryBitMask == bitmasks.player.rawValue && contactB.categoryBitMask == bitmasks.gameOverLine.rawValue{
            gameOver()
        }
    }
    func gameOver(){
        let gameOverScene = GameOverScene(size: self.size)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        view?.presentScene(gameOverScene,transition: transition)
        
        if score > bestScore{
            bestScore = score
            defaults.set(bestScore, forKey: "best")
        }
    }
}
