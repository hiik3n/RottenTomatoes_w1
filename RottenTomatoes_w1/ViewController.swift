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
    var refreshControl: UIRefreshControl!
   
    
    var movies = [NSDictionary]()
    let jsonUrl = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ErrorView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.ErrorView.backgroundColor = UIColor.clearColor()
        self.ErrorView.alpha = 0
        CozyLoadingActivity.show("", disableUI: true)
        
        fetch_movies()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func fetch_movies() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(jsonUrl) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
//                print("error loading from URL", error!)

                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    CozyLoadingActivity.hide()
                    self.ErrorView.text = " ⚠️ Error Network!"
                    self.ErrorView.alpha = 1
                })
                print("error loading from URL")
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.movies = json[ "movies" ] as! [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                CozyLoadingActivity.hide()
                self.ErrorView.alpha = 0
            })
        }
        task.resume()
    }
    
//    func delay(delay:Double, closure:()->()) {
//        dispatch_after(
//            dispatch_time(
//                DISPATCH_TIME_NOW,
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), closure)
//    }
    
    func onRefresh() {
        self.fetch_movies()
        self.refreshControl.endRefreshing()
//        delay(2, closure: {
//            self.fetch_movies()
//            self.refreshControl.endRefreshing()
//        })
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
        cell.imgView.setImageWithURL(thumbnailURL!)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! SecondTableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie: NSDictionary = movies[indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
}

