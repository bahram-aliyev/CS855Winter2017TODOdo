//
//  ToDoImageViewController.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-26.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ToDoImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
 
    var toDoImage: UIImage!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Action handlers
    
    @IBAction func saveImage(_ sender: Any) {
        self.toDoImage = self.cropImage()
    }
    
    @IBAction func cancelImage(_ sender: Any) {
        if(self.presentingViewController is UINavigationController) {
            self.dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = self.navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ToDoEntryController is not inside a navigation controller.")
        }

    }
    
    // MARK: UIScrollViewDelegate
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        self.centerScrollViewContent()
//    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // MARK: Utility methods
    
    // Reference: https://www.youtube.com/watch?v=GMglSsNwoPg
    
    private func initializeScrollView() {
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleToFill
        self.imageView.image = self.toDoImage
        
        self.imageScrollView.contentMode = .scaleToFill
        self.imageScrollView.addSubview(self.imageView)
        self.imageScrollView.delegate = self
        
        
        imageView.frame = CGRect(x: 0, y: 0,
                                    width: self.toDoImage.size.width,
                                        height: self.toDoImage.size.height)
        
        self.imageScrollView.contentSize = self.toDoImage.size
        let scrollViewFrame = self.imageScrollView.frame
        let scaleWidth = scrollViewFrame.size.width / self.imageScrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.imageScrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        self.imageScrollView.minimumZoomScale = minScale
        self.imageScrollView.maximumZoomScale = 1
        self.imageScrollView.zoomScale = minScale
        
//        self.centerScrollViewContent()
    }
    
    private func cropImage() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(self.imageScrollView.bounds.size, true, UIScreen.main.scale)
        let offset = self.imageScrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        imageScrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
//    func centerScrollViewContent(){
//        let boundsSize = imageScrollView.bounds.size
//        var contentsFrame = imageView.frame
//        
//        if contentsFrame.size.width < boundsSize.width{
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
//        }else{
//            contentsFrame.origin.x = 0
//        }
//        
//        if contentsFrame.size.height < boundsSize.height {
//            
//            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
//        }else{
//            contentsFrame.origin.y = 0
//        }
//        
//        imageView.frame = contentsFrame
//    }
}
