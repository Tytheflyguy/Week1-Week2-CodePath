//
//  MoviesViewController.swift
//  movieViewer
//
//  Created by Tyler Anthony on 1/29/16.
//  Copyright © 2016 com.TylerAnthony. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD




class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
/*******
OUTLETS
********/
    //Table View Outlet
    @IBOutlet weak var tableView: UITableView!
    var movies : [NSDictionary]?

    
    
    
    
/*
View Did Load Function
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        

        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            MBProgressHUD.hideHUDForView(self.view, animated: false)

                            
                    }
                
                }
        })
        task.resume()

        
    }
/*
Did Receive Memory Warning Function
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*******
Functions
********/
    
    // NUMBER OF ROWS IN SECTION FUNCTION
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        } else{
            return 0
        }
        
    
    }
    
    // Cell for index path function
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let releaseDate = movie["release_date"] as! String
        let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Float
        let posterPath = movie["poster_path"] as! String
        let base_url = "http://image.tmdb.org/t/p/w500"
        let posterurl = NSURL(string: base_url + posterPath)
        
        
        
        
        
        cell.posterView.setImageWithURL(posterurl!)
        cell.ratingLabel.text = "\(rating)/10"
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
    
        
        return cell
        
    }


    

   
}
