//
//  GameOverScene.swift
//  JumpKing
//
//  Created by 呂淳昇 on 2022/2/18.
//

import Foundation
import SpriteKit

class GameOverScene:SKScene{
    let background = SKSpriteNode(imageNamed: "Background_Clouds")
    let gameOver = SKLabelNode(text: "GAME OVER")
    
    override func didMove(to view: SKView) {
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOver.fontName = "Chalkduster"
        gameOver.fontSize = 64
        gameOver.fontColor = .red
        gameOver.setScale(1.5)
        gameOver.zPosition = 5
        addChild(gameOver)
        
        let tapToRestart = SKLabelNode(text: "Tap To Restart")
        tapToRestart.position = CGPoint(x: size.width / 2, y: size.width / 4)
        tapToRestart.fontName = "Chalkduster"
        tapToRestart.fontSize = 48
        tapToRestart.fontColor = .black
        addChild(tapToRestart)
        
        let outAction = SKAction.fadeOut(withDuration: 0.5)
        let inAction = SKAction.fadeIn(withDuration: 0.5)
        let sequence = SKAction.sequence([outAction,inAction])
        tapToRestart.run(SKAction.repeatForever(sequence))
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        view?.presentScene(gameScene,transition: transition)
    }
}
