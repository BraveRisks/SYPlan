//
//  CoreDataViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/5/7.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController {

    private var tableView: UITableView!
    private var people: [NSManagedObject] = []

    // viewContext --> main thread
    @available(iOS 10.0, *)
    private lazy var viewContext: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // newBackgroundContext() --> 背景thread
    @available(iOS 10.0, *)
    private lazy var backgroundContext: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.newBackgroundContext()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAll()
    }

    private func setup() {
        title = "Core Data Demo"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                      action: #selector(addName(_:)))        
        let addAllItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                         action: #selector(addAll(_:)))
        navigationItem.rightBarButtonItems = [addItem, addAllItem]
        
        let deleteAllItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                            action: #selector(deleteAll(_:)))
        navigationItem.leftBarButtonItem = deleteAllItem

        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func fetchAll() {
        if people.count > 0 { people.removeAll() }
        
        // 取得Core Data內部所有資料
        if #available(iOS 10.0, *) {
            guard let viewContext = viewContext else { return }
            
            // entityName 👉🏻 資料表名稱
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            // 每次取得的筆數
            //fetchRequest.fetchLimit = 2
            
            // 跳過的筆數
            //fetchRequest.fetchOffset = 1
            
            // 排序
            let sort = NSSortDescriptor(key: "age", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            do {
                people = try viewContext.fetch(fetchRequest)
            } catch let err as NSError {
                print("Could not fetch. \(err) 👉🏻 \(err.userInfo)")
            }
        }
    }
    
    @objc private func addName(_ barBtn: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        let save = UIAlertAction(title: "儲存", style: .default) { [unowned self] (action) in
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                    return
            }
            
            if #available(iOS 10.0, *) { self.save(with: name) }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addAll(_ barBtn: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            print("Add record start 👉🏻 \(Date().milliStamp)")
            for _ in 1 ... 1_000 {
                save(with: "\(Int.random(in: -50_000 ... 50_000))")
            }
            print("Add record end  👉🏻 \(Date().milliStamp)")
            tableView.reloadData()
        }
    }
    
    @objc private func deleteAll(_ barBtn: UIBarButtonItem) {
        if #available(iOS 10.0, *) {
            print("Delete record start 👉🏻 \(Date().milliStamp)")
            for i in stride(from: people.count - 1, to: -1, by: -1) {
                delete(with: i)
            }
            print("Delete record end  👉🏻 \(Date().milliStamp)")
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    @available(iOS 10.0, *)
    private func save(with name: String) {
        guard let bgContext = backgroundContext else { return }

        let entity = NSEntityDescription.entity(forEntityName: "Person", in: bgContext)!
        let person = NSManagedObject(entity: entity, insertInto: bgContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(Int.random(in: 1 ... 100), forKey: "age")
        person.setValue(Bool.random(), forKey: "gender")
        
        if bgContext.hasChanges {
            do {
                try bgContext.save()
                people.append(person)
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch let err as NSError {
                print("Could not save. \(err) 👉🏻 \(err.userInfo)")
            }
        }
    }
    
    @available(iOS 10.0, *)
    @objc private func delete(with index: Int) {
        guard let bgContext = backgroundContext else { return }
        
        // 當context不同時，需以objectID來取得對應的object，再做刪除動作
        let obj = bgContext.object(with: people[index].objectID)
        bgContext.delete(obj)
        
        if bgContext.hasChanges {
            do {
                try bgContext.save()
                people.remove(at: index)
            } catch let err as NSError {
                print("Could not delete. \(err) 👉🏻 \(err.userInfo)")
            }
        }
    }
}

extension CoreDataViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        
        let name = person.value(forKeyPath: "name") as? String ?? ""
        let gender = person.value(forKeyPath: "gender") as? Bool ?? false
        let age = person.value(forKeyPath: "age") as? Int ?? 0
        cell.textLabel?.text = "\(gender ? "🙋🏻‍♂️" : "🙋🏻‍♀️") \(name)(\(age))"
        //print("isPerson 👉🏻 \(people[indexPath.row] is Person)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if #available(iOS 10.0, *) {
            delete(with: indexPath.row)
            DispatchQueue.main.async { tableView.reloadData() }
        }
    }
}
