import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    private var squareNode : SKNode?
    private var circleNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // Background
        let backgroundNode = createBackgroundNode(size: self.size, colors: ["#6775F2", "#D585F6"], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        backgroundNode.position = .zero
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        // Circle Node
        createCircleNode()
        
        // Square Node
        let squareNode = createSquareNode(size: CGSize(width: 96, height: 96), blurRadius: 10.0, colors: ["#3D70E5", "#CEFEEC"], bloomIntensity: 1.0, bloomRadius: 10.0)
        self.addChild(squareNode)
    }

    private func createBackgroundNode(size: CGSize, colors: [String], startPoint: CGPoint, endPoint: CGPoint) -> SKSpriteNode {
        let gradientLayer = createGradientLayer(frame: CGRect(origin: .zero, size: size), colors: colors, startPoint: startPoint, endPoint: endPoint)
        let backgroundImage = image(from: gradientLayer)
        let backgroundTexture = SKTexture(image: backgroundImage)
        return SKSpriteNode(texture: backgroundTexture)
    }

    private func createCircleNode() {
        self.circleNode = SKShapeNode(rectOf: CGSize(width: 144, height: 144), cornerRadius: 144)
        circleNode?.lineWidth = 4
        circleNode?.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }

    private func createSquareNode(size: CGSize, blurRadius: CGFloat, colors: [String], bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKNode {
        let squareBodyNode = createSquareBodyNode(size: size, blurRadius: blurRadius, colors: colors)
        let squareStrokeNode = createSquareStrokeNode(size: size, bloomIntensity: bloomIntensity, bloomRadius: bloomRadius)
        
        let squareNode = SKNode()
        squareNode.addChild(squareBodyNode)
        squareNode.addChild(squareStrokeNode)
        return squareNode
    }

    private func createSquareBodyNode(size: CGSize, blurRadius: CGFloat, colors: [String]) -> SKEffectNode {
        let squareBodyNode = SKEffectNode()
        squareBodyNode.shouldRasterize = true
        squareBodyNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": blurRadius])
        
        let gradientLayer = createGradientLayer(frame: CGRect(origin: .zero, size: size), colors: colors, startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        let gradientImage = image(from: gradientLayer)
        
        let squareSprite = SKSpriteNode(texture: SKTexture(image: gradientImage))
        squareBodyNode.addChild(squareSprite)
        return squareBodyNode
    }

    private func createSquareStrokeNode(size: CGSize, bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKEffectNode {
        let squareStrokeNode = SKEffectNode()
        
        let bloomFilter = CIFilter(name: "CIBloom")!
        bloomFilter.setValue(bloomIntensity, forKey: kCIInputIntensityKey)
        bloomFilter.setValue(bloomRadius, forKey: kCIInputRadiusKey)
        
        squareStrokeNode.filter = bloomFilter
        squareStrokeNode.shouldEnableEffects = true
        let borderNode = SKShapeNode(rectOf: size)
        borderNode.strokeColor = SKColor.white
        borderNode.lineWidth = 4
        borderNode.fillColor = SKColor.clear
        squareStrokeNode.addChild(borderNode)
        return squareStrokeNode
    }

    private func createGradientLayer(frame: CGRect, colors: [String], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors.map { UIColor(hex: $0).cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        return gradientLayer
    }

    private func image(from layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func moveSquareNode(toPoint pos: CGPoint) {
        let asstNodeSpeed: CGFloat = 500
        if let squareNode = self.squareNode {
            let distance = hypot(pos.x - squareNode.position.x, pos.y - squareNode.position.y)
            let duration = TimeInterval(distance / asstNodeSpeed)
            
            let moveAction = SKAction.move(to: pos, duration: duration)
            squareNode.run(moveAction)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
//        moveSquareNode(toPoint: pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
//            feedbackGenerator.prepare()
//            feedbackGenerator.impactOccurred()
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
