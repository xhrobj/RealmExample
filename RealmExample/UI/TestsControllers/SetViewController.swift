//
//  SetViewController.swift
//  DataStructures
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

import UIKit

private enum SetVCRow: Int {
    case creation = 0,
    add1Object,
    add5Objects,
    add10Objects,
    remove1Object,
    remove5Objects,
    remove10Objects,
    lookup1Object,
    lookup10Objects
}

struct SetViewState: Codable {
    let numberOfItems: Int
    let creationTime: TimeInterval
    let add1ObjectTime: TimeInterval
    let add5ObjectsTime: TimeInterval
    let add10ObjectsTime: TimeInterval
    let remove1ObjectTime: TimeInterval
    let remove5ObjectsTime: TimeInterval
    let remove10ObjectsTime: TimeInterval
    let lookup1ObjectTime: TimeInterval
    let lookup10ObjectsTime: TimeInterval
}

class SetViewController: DataStructuresViewController {
    
    //MARK: - Variables
    private let fileCache = FileCache<SetViewState>(name: .setTest)
    
    let setManipulator = SwiftSetManipulator()
    
    var creationTime: TimeInterval = 0
    var add1ObjectTime: TimeInterval = 0
    var add5ObjectsTime: TimeInterval = 0
    var add10ObjectsTime: TimeInterval = 0
    var remove1ObjectTime: TimeInterval = 0
    var remove5ObjectsTime: TimeInterval = 0
    var remove10ObjectsTime: TimeInterval = 0
    var lookup1ObjectTime: TimeInterval = 0
    var lookup10ObjectsTime: TimeInterval = 0
    
    //MARK: - Methods
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndTestButton.setTitle("Create Set and Test", for: UIControl.State())
         initWithCache()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cache = SetViewState(
            numberOfItems: numberOfItems,
            creationTime: creationTime,
            add1ObjectTime: add1ObjectTime,
            add5ObjectsTime: add5ObjectsTime,
            add10ObjectsTime: add10ObjectsTime,
            remove1ObjectTime: remove1ObjectTime,
            remove5ObjectsTime: remove5ObjectsTime,
            remove10ObjectsTime: remove10ObjectsTime,
            lookup1ObjectTime: lookup1ObjectTime,
            lookup10ObjectsTime: lookup10ObjectsTime
        )
        fileCache.writeToCache(data: cache)
    }
    
    private func initWithCache() {
        guard let state = fileCache.readFromCache() else {
            return
        }
        numberOfItems = state.numberOfItems
        creationTime = state.creationTime
        add1ObjectTime = state.add1ObjectTime
        add5ObjectsTime = state.add5ObjectsTime
        add10ObjectsTime = state.add10ObjectsTime
        remove1ObjectTime = state.remove1ObjectTime
        remove5ObjectsTime = state.remove5ObjectsTime
        remove10ObjectsTime = state.remove10ObjectsTime
        lookup1ObjectTime = state.lookup1ObjectTime
        lookup10ObjectsTime = state.lookup10ObjectsTime
        updateCountLabel()
        setSliderValueProgrammatically(numberOfItems)
    }
    
    //MARK: Superclass creation/testing overrides
    
    override func create(_ size: Int) {
        creationTime = setManipulator.setupWithObjectCount(size)
    }
    
    override func test() {
        if (setManipulator.setHasObjects()) {
            add1ObjectTime = setManipulator.add1Object()
            add5ObjectsTime = setManipulator.add5Objects()
            add10ObjectsTime = setManipulator.add10Objects()
            remove1ObjectTime = setManipulator.remove1Object()
            remove5ObjectsTime = setManipulator.remove5Objects()
            remove10ObjectsTime = setManipulator.remove10Objects()
            lookup1ObjectTime = setManipulator.lookup1Object()
            lookup10ObjectsTime = setManipulator.lookup10Objects()
        } else {
            print("Set is not set up yet!")
        }
    }
    
    //MARK: Table View Override
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch (indexPath as NSIndexPath).row {
        case SetVCRow.creation.rawValue:
            cell.textLabel!.text = "Set Creation:"
            cell.detailTextLabel!.text = formattedTime(creationTime)
        case SetVCRow.add1Object.rawValue:
            cell.textLabel!.text = "Add 1 Object:"
            cell.detailTextLabel!.text = formattedTime(add1ObjectTime)
        case SetVCRow.add5Objects.rawValue:
            cell.textLabel!.text = "Add 5 Objects:"
            cell.detailTextLabel!.text = formattedTime(add5ObjectsTime)
        case SetVCRow.add10Objects.rawValue:
            cell.textLabel!.text = "Add 10 Objects:"
            cell.detailTextLabel!.text = formattedTime(add10ObjectsTime)
        case SetVCRow.remove1Object.rawValue:
            cell.textLabel!.text = "Remove 1 Object:"
            cell.detailTextLabel!.text = formattedTime(remove1ObjectTime)
        case SetVCRow.remove5Objects.rawValue:
            cell.textLabel!.text = "Remove 5 Objects:"
            cell.detailTextLabel!.text = formattedTime(remove5ObjectsTime)
        case SetVCRow.remove10Objects.rawValue:
            cell.textLabel!.text = "Remove 10 Objects:"
            cell.detailTextLabel!.text = formattedTime(remove10ObjectsTime)
        case SetVCRow.lookup1Object.rawValue:
            cell.textLabel!.text = "Lookup 1 Object:"
            cell.detailTextLabel!.text = formattedTime(lookup1ObjectTime)
        case SetVCRow.lookup10Objects.rawValue:
            cell.textLabel!.text = "Lookup 10 Objects:"
            cell.detailTextLabel!.text = formattedTime(lookup10ObjectsTime)
        default:
            print("Unhandled row! \((indexPath as NSIndexPath).row)")
        }
        
        return cell
    }
}
