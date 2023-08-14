//
//  ViewController.swift
//  Core Graphics
//
//  Created by Tony Alhwayek on 8/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    // Draw a rectangle
    func drawRectangle() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            // Draw the rectangle
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            // Color of rectangle
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            // Color of outline
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // 10 pt border
            ctx.cgContext.setLineWidth(10)
            // Add rectangle
            ctx.cgContext.addRect(rectangle)
            // Draw rectangle
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Draw a circle
    func drawCircle() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            // Draw the circle
            // Insets make the circle fit
            let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            // Color of the circle
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            // Color of outline
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // 10 pt border
            ctx.cgContext.setLineWidth(10)
            // Add circle
            ctx.cgContext.addEllipse(in: circle)
            // Draw circle
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Draw a checkerboard
    func drawCheckerboard() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            // Draw squares in checkerboard
            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Draw rotated squares
    func drawRotatedSquares() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            // Move 256 * 256 into our canvas, so we rotate on the center
            ctx.cgContext.translateBy(x: 256, y: 256)
            // How many times we want to rotate
            let rotations = 16
            // How much to rotate
            // This is cumulative. Each rotation adds to the previous rotation
            // This is how we end up with the end product
            let amount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                // Rotate by amount
                ctx.cgContext.rotate(by: CGFloat(amount))
                // Move back to original spot and draw
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Draw lines
    func drawLines() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            // Draw from center of canvas
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                // Shrink length after each loop
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.strokePath()
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Draw images and text
    func drawImagesAndText() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            // Align text to center
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            // Combine string and attributes in new string
            let attributedstring = NSAttributedString(string: string, attributes: attrs)
            attributedstring.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            // Draw image of mouse
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        // Display the image
        imageView.image = image
    }
    
    // Challenge #1
    // Draw an emoji
    func drawEmoji() {
        // Create renderer
        // This exposes us to context (the canvas)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // Image with the result of our drawing
        // ctx = context
        let image = renderer.image { ctx in
            // Draw the circle
            // Insets make the circle fit
            let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            // Color of the circle
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            // Color of outline
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            // 10 pt border
            ctx.cgContext.setLineWidth(10)
            // Add circle
            ctx.cgContext.addEllipse(in: circle)
            // Draw circle
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Drawing the emoji
            // Left eye
            let eye1 = CGRect(x: 160, y: 150, width: 30, height: 40)
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.addEllipse(in: eye1)
            ctx.cgContext.drawPath(using: .fill)
            
            // Right eye
            let eye2 = CGRect(x: 320, y: 150, width: 30, height: 40)
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.addEllipse(in: eye2)
            ctx.cgContext.drawPath(using: .fill)
            
            // Mouth
            ctx.cgContext.translateBy(x: 256, y: 300)
            var length: CGFloat = 150
            ctx.cgContext.move(to: CGPoint(x: length, y: 0))
            ctx.cgContext.rotate(by: .pi)
            ctx.cgContext.addLine(to: CGPoint(x: length, y: 0))
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.strokePath()
        }
        
        // Display the image
        imageView.image = image
    }
    
    
    
    
    // When button is tapped
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawEmoji()
            
        default:
            break
        }
    }
    
    
    
}

