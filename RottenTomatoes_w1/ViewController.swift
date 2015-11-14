//
//  ViewController.swift
//  RottenTomatoes_w1
//
//  Created by Lam Do on 11/12/15.
//  Copyright © 2015 Lam Do. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [NSDictionary]()
    let jsonUrl = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(jsonUrl) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                print("error loading from URL", error!)
                return
            }
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.movies = json[ "movies" ] as! [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! SecondTableViewCell
        let movie: NSDictionary = movies[indexPath.row]
        cell.tableViewCell.text = movie["title"] as! String?
        cell.SummaryView.text = movie["synopsis"] as! String?
        let posters = movie["posters"] as! NSDictionary
        let thumbnailString = posters["thumbnail"] as! String
        let thumbnailURL = NSURL(string: thumbnailString)
//        print("setting thumbnail", thumbnailURL)
        cell.imgView.setImageWithURL(thumbnailURL!)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! SecondTableViewCell
        let indexPath = tableView.indexPathForCell(cell)
//        let movie = movies[indexPath!.row]
        let movie: NSDictionary = movies[indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
}

