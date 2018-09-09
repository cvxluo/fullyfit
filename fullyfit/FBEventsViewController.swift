//
//  ViewController.swift
//  fullyfit
//
//  Created by Charlie Luo on 9/8/18.
//

import UIKit
import FacebookCore
import FacebookLogin

class FBEventsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    var accessToken:AccessToken?
    
    var events = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.separatorStyle = .none
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        let stringUrl = "https://graph.facebook.com" + accessToken!.authenticationToken + "?fields=events"
        
        let url = URL(string: stringUrl)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.events.append(["Pennapps" : "yes"])
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell1")! as UITableViewCell
        cell.textLabel?.text = self.events[indexPath.row]["name"] as! String
        cell.textLabel!.font = UIFont.systemFont(ofSize: 24)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


