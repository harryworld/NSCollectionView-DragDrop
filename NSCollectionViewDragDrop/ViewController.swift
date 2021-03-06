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
    var draggingItem: NSCollectionViewItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.registerForDraggedTypes([NSPasteboardTypeString])
        
        collectionView.backgroundColors = [NSColor.blackColor()]
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func addToTop(sender: AnyObject) {
        strings.insert("Top", atIndex: 0)
        
        let indexPaths: Set<NSIndexPath> = [NSIndexPath(forItem: 0, inSection: 0)]
        collectionView.animator().performBatchUpdates({
            self.collectionView.scrollPoint(NSPoint(x: 0, y: 0))
            self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }

    @IBAction func removeFromTop(sender: AnyObject) {
        guard strings.count > 0 else { return }
        
        strings.removeFirst()
        
        let indexPaths: Set<NSIndexPath> = [NSIndexPath(forItem: 0, inSection: 0)]
        collectionView.animator().performBatchUpdates({
            self.collectionView.animator().deleteItemsAtIndexPaths(indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }
    
    @IBAction func replaceLast(sender: AnyObject) {
        guard strings.count > 0 else { return }
        
        strings.removeLast()
        strings.append("Last")
        
        let indexPaths: Set<NSIndexPath> = [NSIndexPath(forItem: strings.count - 1, inSection: 0)]
        
        collectionView.animator().performBatchUpdates({
            self.collectionView.deleteItemsAtIndexPaths(indexPaths)
            self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }
    
    @IBAction func scrollTo(sender: AnyObject) {
        let rect = collectionView.frameForItemAtIndex(2)
        //collectionView.scrollPoint(rect.origin)
        
        let clipView = collectionView.enclosingScrollView!.contentView
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = 2
        clipView.animator().setBoundsOrigin(rect.origin)
        NSAnimationContext.endGrouping()
        
        clipView.postsBoundsChangedNotifications = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "boundsDidChange:", name: NSViewBoundsDidChangeNotification, object: clipView)
    }
    
    func boundsDidChange(notification: NSNotification) {
        print("boundsDidChange")
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
        
        if let indexPath = draggingIndexPaths.first,
            item = collectionView.itemAtIndexPath(indexPath) {
            draggingItem = item
        }
    }
    
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        draggingIndexPaths = []
        draggingItem = nil
    }
    
    func collectionView(collectionView: NSCollectionView, pasteboardWriterForItemAtIndexPath indexPath: NSIndexPath) -> NSPasteboardWriting? {
        let pb = NSPasteboardItem()
        pb.setString(strings[indexPath.item], forType: NSPasteboardTypeString)
        return pb
    }
    
    func collectionView(collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath?>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        
        if let proposedDropIndexPath = proposedDropIndexPath.memory,
            draggingItem = draggingItem,
            currentIndexPath = collectionView.indexPathForItem(draggingItem)
            where currentIndexPath != proposedDropIndexPath {
            
            collectionView.animator().moveItemAtIndexPath(currentIndexPath, toIndexPath: proposedDropIndexPath)
        }
        
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
    
    func collectionView(collectionView: NSCollectionView, draggingImageForItemsAtIndexPaths indexPaths: Set<NSIndexPath>, withEvent event: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        return NSImage(named: NSImageNameFolder)!
    }
    
    func collectionView(collectionView: NSCollectionView, draggingImageForItemsAtIndexes indexes: NSIndexSet, withEvent event: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        return NSImage(named: NSImageNameFolder)!
    }
    
}
