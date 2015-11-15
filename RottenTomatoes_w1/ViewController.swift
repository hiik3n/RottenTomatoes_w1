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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                print("error loading from URL")
                CozyLoadingActivity.hide()
                //Create the AlertController
                
                let actionSheetController: UIAlertController = UIAlertController(title: "Network Error", message: "Please re-check your network connection!", preferredStyle: UIAlertControllerStyle.Alert)
                
                //Create and add the OK action
                let OkAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    //Do some stuff
                    CozyLoadingActivity.show("", disableUI: true)
                    self.fetch_movies()
                }
                actionSheetController.addAction(OkAction)
                
                //Create and add the Cancel action
                let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                    //Do some stuff
                    return
                }
                actionSheetController.addAction(CancelAction)
                
                //Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
                return
            }
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.movies = json[ "movies" ] as! [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                CozyLoadingActivity.hide()
            })
        }
        task.resume()
    }
    
    @IBAction func showAlertTapped(sender: AnyObject) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Swiftly Now! Choose an option!", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Next", style: .Default) { action -> Void in
            //Do some other stuff
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.blueColor()
        }
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
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

