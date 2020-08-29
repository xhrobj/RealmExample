//
//  DictionaryViewController.swift
//  DataStructures
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

import UIKit

private enum DictionaryVCRow: Int {
    case creation = 0,
    add1Entry,
    add5Entries,
    add10Entries,
    remove1Entry,
    remove5Entries,
    remove10Entries,
    lookup1Entry,
    lookup10Entries
}

struct DictionaryViewState: Codable {
    let numberOfItems: Int
    let creationTime: TimeInterval
    let add1EntryTime: TimeInterval
    let add5EntriesTime: TimeInterval
    let add10EntriesTime: TimeInterval
    let remove1EntryTime: TimeInterval
    let remove5EntriesTime: TimeInterval
    let remove10EntriesTime: TimeInterval
    let lookup1EntryTime: TimeInterval
    let lookup10EntriesTime: TimeInterval
}

class DictionaryViewController: DataStructuresViewController {
    
    //MARK: - Variables
    private let fileCache = FileCache<DictionaryViewState>(name: .dictionaryTest)
    
    let dictionaryManipulator: DictionaryManipulator = SwiftDictionaryManipulator()
    
    var creationTime: TimeInterval = 0
    var add1EntryTime: TimeInterval = 0
    var add5EntriesTime: TimeInterval = 0
    var add10EntriesTime: TimeInterval = 0
    var remove1EntryTime: TimeInterval = 0
    var remove5EntriesTime: TimeInterval = 0
    var remove10EntriesTime: TimeInterval = 0
    var lookup1EntryTime: TimeInterval = 0
    var lookup10EntriesTime: TimeInterval = 0
    
    //MARK: - Methods
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndTestButton.setTitle("Create Dictionary and Test", for: UIControl.State())
        initWithCache()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cache = DictionaryViewState(
            numberOfItems: numberOfItems,
            creationTime: creationTime,
            add1EntryTime: add1EntryTime,
            add5EntriesTime: add5EntriesTime,
            add10EntriesTime: add10EntriesTime,
            remove1EntryTime: remove1EntryTime,
            remove5EntriesTime: remove5EntriesTime,
            remove10EntriesTime: remove10EntriesTime,
            lookup1EntryTime: lookup1EntryTime,
            lookup10EntriesTime: lookup10EntriesTime
        )
        fileCache.writeToCache(data: cache)
    }
    
    private func initWithCache() {
        guard let state = fileCache.readFromCache() else {
            return
        }
        numberOfItems = state.numberOfItems
        creationTime = state.creationTime
        add1EntryTime = state.add1EntryTime
        add5EntriesTime = state.add5EntriesTime
        add10EntriesTime = state.add10EntriesTime
        remove1EntryTime = state.remove1EntryTime
        remove5EntriesTime = state.remove5EntriesTime
        remove10EntriesTime = state.remove10EntriesTime
        lookup1EntryTime = state.lookup1EntryTime
        lookup10EntriesTime = state.lookup10EntriesTime
        updateCountLabel()
        setSliderValueProgrammatically(numberOfItems)
    }
    
    //MARK: Superclass creation/testing overrides
    
    override func create(_ size: Int) {
        creationTime = dictionaryManipulator.setupWithEntryCount(size)
    }
    
    override func test() {
        if dictionaryManipulator.dictHasEntries() {
            add1EntryTime = dictionaryManipulator.add1Entry()
            add5EntriesTime = dictionaryManipulator.add5Entries()
            add10EntriesTime = dictionaryManipulator.add10Entries()
            remove1EntryTime = dictionaryManipulator.remove1Entry()
            remove5EntriesTime = dictionaryManipulator.remove5Entries()
            remove10EntriesTime = dictionaryManipulator.remove10Entries()
            lookup1EntryTime = dictionaryManipulator.lookup1EntryTime()
            lookup10EntriesTime = dictionaryManipulator.lookup10EntriesTime()
        } else {
            print("Dictionary not yet set up!")
        }
    }
    
    //MARK: Table View Override
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch (indexPath as NSIndexPath).row {
        case DictionaryVCRow.creation.rawValue:
            cell.textLabel!.text = "Dictionary Creation:"
            cell.detailTextLabel!.text = formattedTime(creationTime)
        case DictionaryVCRow.add1Entry.rawValue:
            cell.textLabel!.text = "Add 1 Entry:"
            cell.detailTextLabel!.text = formattedTime(add1EntryTime)
        case DictionaryVCRow.add5Entries.rawValue:
            cell.textLabel!.text = "Add 5 Entries:"
            cell.detailTextLabel!.text = formattedTime(add5EntriesTime)
        case DictionaryVCRow.add10Entries.rawValue:
            cell.textLabel!.text = "Add 10 Entries:"
            cell.detailTextLabel!.text = formattedTime(add10EntriesTime)
        case DictionaryVCRow.remove1Entry.rawValue:
            cell.textLabel!.text = "Remove 1 Entry:"
            cell.detailTextLabel!.text = formattedTime(remove1EntryTime)
        case DictionaryVCRow.remove5Entries.rawValue:
            cell.textLabel!.text = "Remove 5 Entries:"
            cell.detailTextLabel!.text = formattedTime(remove5EntriesTime)
        case DictionaryVCRow.remove10Entries.rawValue:
            cell.textLabel!.text = "Remove 10 Entries:"
            cell.detailTextLabel!.text = formattedTime(remove10EntriesTime)
        case DictionaryVCRow.lookup1Entry.rawValue:
            cell.textLabel!.text = "Lookup 1 Entry:"
            cell.detailTextLabel!.text = formattedTime(lookup1EntryTime)
        case DictionaryVCRow.lookup10Entries.rawValue:
            cell.textLabel!.text = "Lookup 10 Entries:"
            cell.detailTextLabel!.text = formattedTime(lookup10EntriesTime)
        default:
            print("Unhandled row! \((indexPath as NSIndexPath).row)")
        }
        
        return cell
    }
}
