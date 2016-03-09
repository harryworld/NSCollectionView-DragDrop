//
//  MyView.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 2/3/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

@IBDesignable class MyView: NSView {
    
    var leftArrowLayer: CAShapeLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        wantsLayer = true
        
        leftArrowLayer = createArrow()
        leftArrowLayer.opacity = 1
        layer?.addSublayer(leftArrowLayer)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        layer?.backgroundColor = NSColor.yellowColor().CGColor
        
        leftArrowLayer.position = NSPoint(x: 30, y: bounds.height / 2)
    }
    
    override func prepareForInterfaceBuilder() {
        layer?.backgroundColor = NSColor.redColor().CGColor
    }
    
    func createArrow() -> CAShapeLayer {
        let rect = CGRectMake(0, 0, 3, 10)
        
        let leftArrow = NSBezierPath()
        leftArrow.moveToPoint(CGPointMake(0, 0))
        leftArrow.lineToPoint(CGPointMake(rect.width, rect.height / 2))
        leftArrow.lineToPoint(CGPointMake(0, rect.height))
        
        let shape = CAShapeLayer()
        shape.strokeColor = NSColor.blueColor().CGColor
        shape.lineWidth = 2
        shape.path = leftArrow.toCGPath()
        shape.bounds = rect
        
        return shape
    }
    
}
