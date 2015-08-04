//
//  PhotoViewController.swift
//  ios-challenge
//
//  Created by Thales Pereira on 8/3/15.
//  Copyright (c) 2015 Thales Pereira. All rights reserved.
//

import UIKit

import SwiftyJSON
import JTSImageViewController

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var photo: Photo!
    var comments: [Comment] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Use this photoId for get some comments for test
        var photoId: String = "14416292522"
        
        // Use this photoId for get original comments
        //var photoId: String = self.photo.id!
        
        FlickrApiManager.sharedInstance.commentsGetList(photoId, onCompletion: { (comments, error) in
            self.comments = comments.reverse()

            self.tableView.reloadData()
            
            self.tableView.estimatedRowHeight = 44.0
            self.tableView.rowHeight = UITableViewAutomaticDimension
        })
    }
    
    // MARK: - JTSImageViewController
    
    func openImageView() {
        var imageInfo = JTSImageInfo()
        imageInfo.imageURL = self.photo.photoUrl()
        
        var imageViewer = JTSImageViewController(
            imageInfo: imageInfo,
            mode: JTSImageViewControllerMode.Image,
            backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOffscreen)
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var cell: PhotoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("PhotoInfoCell") as! PhotoTableViewCell
            
            cell.photoImagem.kf_setImageWithURL(self.photo.photoUrl())
            
            var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("openImageView"))
            cell.photoImagem.addGestureRecognizer(tapGestureRecognizer)
            
            cell.photoTitle.text = self.photo.title
            cell.photoDescription.text = self.photo.desc
            cell.photoDateAuthor.text = self.photo.postedString() +
                " • " + String(self.photo.views!) + " views" +
                " • " + self.photo.author!
            cell.photoComments.text = "Comments (\(self.photo.comments!))"
            
            return cell
        } else {
            var cell:CommentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentTableViewCell
            
            let index: Int = indexPath.row - 1
            
            cell.commentAuthorPhoto.kf_setImageWithURL(self.comments[index].buddyIconUrl())
            
            cell.commentAuthor.text = self.comments[index].author
            cell.commentDate.text = self.comments[index].createdString()
            cell.commentMessage.text = self.comments[index].message
            
            return cell
        }
    }
    
}
