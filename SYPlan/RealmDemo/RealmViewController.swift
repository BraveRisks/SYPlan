//
//  RealmViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/5/10.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import RealmSwift

class RealmViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var people: Results<RealmPerson>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        title = "Realm Demo"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                      action: #selector(addName(_:)))
        let addAllItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                         action: #selector(addAll(_:)))
        navigationItem.rightBarButtonItems = [addItem, addAllItem]
         
        let deleteAllItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
        action: #selector(deleteAll(_:)))
        navigationItem.leftBarButtonItem = deleteAllItem
        
        /*
         壓力測試 讀取
         1000筆  1557989085417 - 1557989085437 = 0.020s
         1000筆  1557989129745 - 1557989129767 = 0.022s
         5000筆  1557989297486 - 1557989297508 = 0.022s
         5000筆  1557989331246 - 1557989331269 = 0.023s
         10000筆 1557989484481 - 1557989484503 = 0.022s
         10000筆 1557989522995 - 1557989523017 = 0.022s
         20000筆 1557989750897 - 1557989750918 = 0.021s
         20000筆 1557989850746 - 1557989850766 = 0.020s
         */
        // CACurrentMediaTime()
        print("Read start 👉🏻 \(Date().milliStamp)")
        let sortDisc = [SortDescriptor(keyPath: "name", ascending: true),
                        SortDescriptor(keyPath: "age", ascending: false)]
        people = try! Realm().objects(RealmPerson.self).sorted(by: sortDisc)
        print("Read end   👉🏻 \(Date().milliStamp)")
        
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
    
    @objc private func addName(_ barBtn: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let save = UIAlertAction(title: "儲存", style: .default) { [unowned self] (action) in
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                    return
            }
            
            self.save(with: name)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func save(with name: String) {
        let person = RealmPerson()
        person.name = name
        person.age = RealmOptional(Int.random(in: 1 ... 100))
        person.gender = RealmOptional(Bool.random())
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(person)
        }
        
        //people = realm.objects(RealmPerson.self)
        //tableView.reloadData()
    }
    
    @objc private func addAll(_ barBtn: UIBarButtonItem) {
        print("Add record start 👉🏻 \(Date().milliStamp)")
        /*
         壓力測試 新增
         1000筆  1557989022124 - 1557989023840 = 1.7s
         1000筆  1557989161525 - 1557989163245 = 1.7s
         5000筆  1557989243821 - 1557989252312 = 8.4s
         5000筆  1557989368475 - 1557989377190 = 8.7s
         10000筆 1557989441617 - 1557989460148 = 18.5s
         10000筆 1557989583920 - 1557989565783 = 18.1s
         20000筆 1557989657743 - 1557989698957 = 43.9s
         20000筆 1557989894960 - 1557989936431 = 41.4s
         */
        for _ in 1 ... 20_000 {
            save(with: "\(Int.random(in: -50_000 ... 50_000))")
        }
        print("Add record end  👉🏻 \(Date().milliStamp)")
        people = try! Realm().objects(RealmPerson.self)
        tableView.reloadData()
    }
    
    @objc private func deleteAll(_ barBtn: UIBarButtonItem) {
        /*
         壓力測試 刪除
         1000筆  1557989154344 - 1557989154352 = 0.008s
         1000筆  1557989195765 - 1557989195771 = 0.006s
         5000筆  1557989349851 - 1557989349860 = 0.009s
         5000筆  1557989392925 - 1557989392931 = 0.006s
         10000筆 1557989539700 - 1557989539712 = 0.012s
         10000筆 1557989607722 - 1557989607732 = 0.010s
         20000筆 1557989870993 - 1557989871013 = 0.020s
         20000筆 1557989956370 - 1557989956380 = 0.010s
         */
        print("Delete record start 👉🏻 \(Date().milliStamp)")
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        print("Delete record end  👉🏻 \(Date().milliStamp)")
        tableView.reloadData()
    }
}

extension RealmViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        
        let name = person.name
        let age = person.age.value ?? 0
        let gender = person.gender.value ?? false
        cell.textLabel?.text = "\(gender ? "🙋🏻‍♂️" : "🙋🏻‍♀️") \(name)(\(age))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
