//
//  ViewController.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 27/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var strings = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var draggingIndexPaths: Set<NSIndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.registerForDraggedTypes([NSPasteboardTypeString])
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return strings.count
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        return collectionView.makeItemWithIdentifier("MyItem", forIndexPath: indexPath)
    }
    
}

extension ViewController: NSCollectionViewDelegate {
    
    func collectionView(collectionView: NSCollectionView, willDisplayItem item: NSCollectionViewItem, forRepresentedObjectAtIndexPath indexPath: NSIndexPath) {
        item.textField?.stringValue = "\(strings[indexPath.item]) \(indexPath.item)"
    }
    
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        draggingIndexPaths = indexPaths
    }
    
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        draggingIndexPaths = []
    }
    
    func collectionView(collectionView: NSCollectionView, pasteboardWriterForItemAtIndexPath indexPath: NSIndexPath) -> NSPasteboardWriting? {
        let pb = NSPasteboardItem()
        pb.setString(strings[indexPath.item], forType: NSPasteboardTypeString)
        return pb
    }
    
    func collectionView(collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath?>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        return .Move
    }
    
    func collectionView(collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: NSIndexPath, dropOperation: NSCollectionViewDropOperation) -> Bool {
        for fromIndexPath in draggingIndexPaths {
            let temp = strings.removeAtIndex(fromIndexPath.item)
            strings.insert(temp, atIndex: (indexPath.item <= fromIndexPath.item) ? indexPath.item : (indexPath.item - 1))
            
            //NSAnimationContext.currentContext().duration = 0.5
            collectionView.animator().moveItemAtIndexPath(fromIndexPath, toIndexPath: indexPath)
        }
        
        return true
    }
    
}
