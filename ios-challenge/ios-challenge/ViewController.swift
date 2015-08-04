//
//  ViewController.swift
//  ios-challenge
//
//  Created by Thales Pereira on 8/2/15.
//  Copyright (c) 2015 Thales Pereira. All rights reserved.
//

import UIKit

import Kingfisher
import SwiftSpinner
    
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [Photo] = []
    let photosPerPage: Int = 20
    var currentPage: Int = 0
    var selectedPhoto: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "LoadingCollectionViewCell")
    }

    // MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item < self.photos.count {
            return photoCellForIndexPath(indexPath)
        } else {
            fetchMorePhotos()
            
            return loadingCellForIndexPath(indexPath)
        }
    }
    
    func photoCellForIndexPath(indexPath: NSIndexPath) -> PhotoCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.photo.kf_setImageWithURL(photos[indexPath.row].photoUrl())
        
        return cell
    }
    
    func loadingCellForIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LoadingCollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width * 0.5, height: collectionView.frame.size.width * 0.5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPhoto = photos[indexPath.row]
        
        SwiftSpinner.show("Downloading photo information...")
        
        FlickrApiManager.sharedInstance.photosGetInfo(selectedPhoto, onCompletion: { (info, error) in
            SwiftSpinner.hide()
            self.performSegueWithIdentifier("seguePhoto", sender: self)
        })
    }
    
    // MARK: - Network Requests
    
    func fetchMorePhotos() {
        currentPage++
        
        self.showLoadingStatus()
        
        FlickrApiManager.sharedInstance.photosGetRecent(photosPerPage, page: currentPage, onCompletion: { (photos, error) in
            self.photos += photos
            self.collectionView.reloadData()
            
            self.hideLoadingStatus()
        })
    }
    
    // MARK: - Activity Indicator
    
    func showLoadingStatus() {
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.startAnimating()
        
        var rightButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func hideLoadingStatus() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "seguePhoto") {
            let viewController: PhotoViewController = segue.destinationViewController as! PhotoViewController
            viewController.photo = selectedPhoto
        }
    }
    
}

