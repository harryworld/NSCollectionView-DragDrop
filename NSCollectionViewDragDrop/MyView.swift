//
//  MyView.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 2/3/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class MyView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        NSColor.yellowColor().setFill()
        NSRectFill(dirtyRect)
    }
    
}
