//
//  ViewController.swift
//  MyMoney
//
//  Created by Kevin Tan on 2/14/18.
//  Copyright © 2018 ACM Hack. All rights reserved.
//

import UIKit

struct MoneyEntry {
    var money: Double
    var description: String
}

class ViewController: UIViewController, AddEntryDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var m_moneyPath: String!
    private var m_entries = [MoneyEntry]()
    
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var entryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        
        let moneyPath = documentsPath.appending("/MyMoney")
        m_moneyPath = moneyPath.appending("/money.txt")
        
        var objcBool: ObjCBool = false
        if !FileManager.default.fileExists(atPath: moneyPath, isDirectory: &objcBool) {
            do {
                try FileManager.default.createDirectory(atPath: moneyPath, withIntermediateDirectories: true, attributes: nil)
                
                FileManager.default.createFile(atPath: m_moneyPath, contents: nil, attributes: nil)
                
                moneyLabel.text = "$0.00"
            }
                
            catch {
                print("failed to create Money directory")
            }
            
        }
        
        else {
            
            do {
                let rawEntries = try String(contentsOfFile: m_moneyPath, encoding: .utf8)
                
                let lines = rawEntries.components(separatedBy: .newlines)
                var totalMoney: Double = 0
                for line in lines {
                    if line == "" {
                        continue
                    }
                    
                    let components = line.components(separatedBy: ",")
                    
                    let money = Double(components[0])!
                    totalMoney += money
                    
                    let entry = MoneyEntry(money: money, description: components[1])
                    m_entries.append(entry)
                }
                
                moneyLabel.text = "$" + String(format: "%.2f", totalMoney)
            }
            
            catch {
                print("failed to read money entry file")
            }
            
        }
        
        entryTable.delegate = self
        entryTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AddEntryViewController {
            destination.delegate = self
        }
        
        super.prepare(for: segue, sender: sender)
        
    }
    
    func didAddEntry(_ entry: MoneyEntry) {
        m_entries.append(entry)
        entryTable.reloadData()
        
        let totalMoney = Double(moneyLabel.text!.dropFirst())! + entry.money
        moneyLabel.text = "$" + String(format: "%.2f", totalMoney)
        
        var stringEntry = ""
        for entry in m_entries {
            stringEntry += String(entry.money) + "," + entry.description + "\n"
        }
        
        do {
            try stringEntry.write(toFile: m_moneyPath, atomically: false, encoding: .utf8)
        }
        
        catch {
            print("could not write")
        }
    }
    
    // MARK: TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell") else {
            fatalError()
        }
        
        let entries = Array(m_entries.reversed())
        print(String(entries[indexPath.row].money))
        print(entries[indexPath.row].description)
        cell.textLabel?.text = "$" + String(entries[indexPath.row].money)
        cell.detailTextLabel?.text = entries[indexPath.row].description
        
        return cell
        
    }
    
}

