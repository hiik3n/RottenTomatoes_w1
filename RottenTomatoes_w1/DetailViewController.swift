//
//  DetailViewController.swift
//  RottenTomatoes_w1
//
//  Created by Lam Do on 11/14/15.
//  Copyright © 2015 Lam Do. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImgView: UIImageView!
    @IBOutlet weak var detailTitleView: UILabel!
    @IBOutlet weak var detailYearView: UILabel!
    @IBOutlet weak var detailTimeView: UILabel!
    @IBOutlet weak var detailDayView: UILabel!
    @IBOutlet weak var detailActorsView: UILabel!
    @IBOutlet weak var detailSumView: UITextView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CozyLoadingActivity.show("Loading...", disableUI: true)
        detailTitleView.text = (movie["title"] as? String)! + " (" + String(movie["year"] as! Int) + ")"
        detailTimeView.text = "Length: \n" + String(movie["runtime"] as! Int) + " mins"
        detailDayView.text = "Release Date: \n" + (movie.valueForKeyPath("release_dates.theater") as! String)
//        print(movie.valueForKeyPath("release_dates.theater"))
//        detailActorsView.text = movie.valueForKeyPath("abridged_cast.") as? String
//        let actors = movie["abridged_cast"] as! NSArray
//        for var index = 0; index < actors.count; ++index        {
//            print((actors[index] as! NSDictionary)["name"] as! String)
//            print(((actors[index] as! NSDictionary)["characters"] as! NSArray)[0] as! String)
//        }
        detailSumView.text = movie["synopsis"] as! String
        detailImgView.setImageWithURL(NSURL(string: (movie.valueForKeyPath("posters.detailed") as! String))!)
//        let urlString = movie.valueForKeyPath("posters.detailed") as! String
//        let imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        CozyLoadingActivity.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
