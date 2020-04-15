//
//  ViewController.swift
//  RandomList
//
//  Created by user on 3/26/20.
//  Copyright © 2020 user. All rights reserved.
//

import Cocoa
import SwiftUI
class ViewController: NSViewController {
    
    @IBOutlet private weak var namesTablevIew: NSTableView!
    @IBOutlet private weak var addNameTextField: NSTextField!
    @IBOutlet private weak var myLabel: NSTextField!
    var personsArray: [String]?
    let nameCell = "names"
    var image: NSImage?
    var text: String = ""
    var cellIdentifier: String = ""
    var selectedArray: [String] = []
    var arrayCount: Int = 0
    var choosenPerson: String = ""
    var timerTest: Timer?
    var tableRow: Int = 0
    var count: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        personsArray = []
        personsArray = UserDefaults.standard.array(forKey: "personsArray") as? [String] ?? []
        namesTablevIew.delegate = self
        namesTablevIew.dataSource = self
        namesTablevIew.target = self
        namesTablevIew.doubleAction = #selector(tableViewDoubleClick(_:))
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @objc
    func tableViewDoubleClick(_ sender: NSTableView) {
        let row = tableRow
        personsArray?.remove(at: row)
        namesTablevIew.removeRows(at: IndexSet(integer: row ), withAnimation: .effectFade)
        UserDefaults.standard.setValue(personsArray, forKey: "personsArray")
        namesTablevIew.reloadData()
        
    }
    
    @IBAction func addPerson(_ sender: Any) {
        let nameAdded = addNameTextField.stringValue
        if (nameAdded != "") {
            personsArray?.append(nameAdded)
            namesTablevIew.reloadData()
            addNameTextField.stringValue = ""
            UserDefaults.standard.setValue(personsArray, forKey: "personsArray")
        }
    }
    
    @objc
    func updateLabel() {
        var labelArray = selectedArray
        if (arrayCount < labelArray.count ) {
            
            let nameeeeeeee = labelArray[arrayCount]
            myLabel.stringValue = nameeeeeeee
            arrayCount += 1
            myLabel.pushTransition(0.4)
        } else {
            myLabel.stringValue = choosenPerson
            stopTimerTest()
            labelArray = []
            arrayCount = 0
            
        }
    }
    @IBAction func choosePerson(_ sender: Any) {
        
        chooseRandome()
    }
    func showAlert(name: String) {
        let alert = NSAlert()
        alert.messageText = "The Choosen Person"
        alert.informativeText = name
        alert.beginSheetModal(for: self.view.window ?? NSWindow()) { (_) in
        }
    }
    
    func chooseRandome() {
         count = selectedArray.count
        if (count ?? 0 > 0) {
            if((count ?? 0) % 2 == 0) {
                print("\(String(describing: count)) is even")
                let median = (count ?? 0) / 2
                choosenPerson = selectedArray[median - 1]
            } else {
                print("\(String(describing: count)) is odd")
                let median = ((count ?? 0) + 1) / 2
                choosenPerson = selectedArray[median - 1]
                
            }
            startTimer()
        }
    }
    
    func startTimer () {
        guard timerTest == nil else { return }
        timerTest = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.5),
            target: self,
            selector: #selector(self.updateLabel),
            userInfo: nil,
            repeats: true)
    }
    func stopTimerTest() {
        timerTest?.invalidate()
        timerTest = nil
    }
    
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return personsArray?.count ?? 0
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let currentPerson = personsArray?[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "nameColumn" ) {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: nameCell)
            if selectedArray.contains(currentPerson ?? "") {
                guard let cellView = tableView
                    .makeView(withIdentifier: cellIdentifier,
                              owner: self) as? NSTableCellView else { return nil }
                cellView.textField?.stringValue = currentPerson ?? ""
                cellView.imageView?.isHidden = false
                return cellView
                
            } else {
                guard let cellView = tableView
                    .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "textCell"),
                              owner: self) as? NSTableCellView else { return nil }
                cellView.textField?.stringValue = currentPerson ?? ""
                
                return cellView
                
            }
            
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 21.0
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = namesTablevIew.selectedRow
        if selectedRow >= 0 || namesTablevIew.selectedRowIndexes.count == 1 {
            if let name = personsArray?[selectedRow] {
                tableRow = selectedRow
                if selectedArray.contains(name) {
                    print("noooo")
                    _ = namesTablevIew
                        .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "names"),
                                  owner: self) as? NSTableCellView
                    if let index = selectedArray.firstIndex(of: name) {
                        selectedArray.remove(at: index)
                    }
                    namesTablevIew.reloadData()
                } else {
                    print("nnnnn", name)
                    _ = namesTablevIew
                        .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "textCell"),
                                  owner: self) as? NSTableCellView
                    selectedArray.append(name)
                    namesTablevIew.reloadData()
                }
            }
        }
        
    }
}

extension NSView {
    func pushTransition(_ duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer?.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
