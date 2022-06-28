//
//  ContentView.swift
//  JumpKing
//
//  Created by 呂淳昇 on 2022/2/16.
//

import SwiftUI
import SpriteKit

class StartScene:SKScene{
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "startButton"{
                let gameScene = GameScene(size: self.size)
                let transition = SKTransition.crossFade(withDuration: 2)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
struct ContentView: View {
    let startScene = StartScene(fileNamed: "StartScene")!
    var body: some View {
        SpriteView(scene: startScene).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
