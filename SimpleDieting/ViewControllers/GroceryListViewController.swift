//
//  GroceryListViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 8/3/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var groceryListScrollView: UIScrollView!
    @IBOutlet weak var groceryListImageView: UIImageView!
    
    var pinchFingers = UIPinchGestureRecognizer()
    var panFingers = UIPanGestureRecognizer()
    var singleTap = UITapGestureRecognizer()
    var doubleTap = UITapGestureRecognizer()
    var isZoomedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceryListScrollView.delegate = self
        groceryListScrollView.minimumZoomScale = 1.0
        groceryListScrollView.maximumZoomScale = 3.75
        groceryListImageView.isUserInteractionEnabled = true
        groceryListScrollView.isUserInteractionEnabled = true
        setupForGestures()
        // Do any additional setup after loading the view.
    }

    // MARK - Delegates
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return groceryListImageView
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK - Gestures
    func setupForGestures() {
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(tapTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        doubleTap.cancelsTouchesInView = false
        groceryListImageView.addGestureRecognizer(doubleTap)
        groceryListScrollView.addGestureRecognizer(doubleTap)
        doubleTap.delegate = self
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        singleTap.require(toFail: doubleTap)
        singleTap.numberOfTapsRequired = 1
        singleTap.delaysTouchesBegan = true
        singleTap.cancelsTouchesInView = false
        groceryListImageView.addGestureRecognizer(singleTap)
        groceryListScrollView.addGestureRecognizer(singleTap)
        singleTap.delegate = self
        
        pinchFingers = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        groceryListImageView.addGestureRecognizer(pinchFingers)
        groceryListScrollView.addGestureRecognizer(pinchFingers)
        pinchFingers.delegate = self
        
        panFingers = UIPanGestureRecognizer(target: self, action: #selector(pan))
        groceryListImageView.addGestureRecognizer(panFingers)
        groceryListScrollView.addGestureRecognizer(panFingers)
        panFingers.delegate = self
    }
    
    // MARK - Gesture actions
    
    @objc func tap(gestureRecognizer gesture: UIGestureRecognizer) {
        // ignore single tap
    }
    
    @objc func tapTap(gestureRecognizer gesture: UIGestureRecognizer) {
        var scrollView = UIScrollView()
        if (gesture.view?.isKind(of: UIScrollView.self))! {
            scrollView = gesture.view as! UIScrollView
        }
        if isZoomedIn {
            scrollView.contentOffset = CGPoint.zero
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
            isZoomedIn = false
        } else {
            let point = gesture.location(in: scrollView)
            scrollView.contentOffset = CGPoint.init(x: point.x - scrollView.bounds.size.width/2, y: point.y - scrollView.bounds.size.height/2)
            scrollView.zoomScale = scrollView.maximumZoomScale
            isZoomedIn = true
        }
    }
    
    @objc func pinch(gestureRecognizer gesture : UIPinchGestureRecognizer){
        if (gesture.view as! UIScrollView).zoomScale > (gesture.view as! UIScrollView).zoomScale {
            isZoomedIn = true
        } else {
            isZoomedIn = false
        }
//        if let imageView = gesture.view {
//            imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
//            gesture.scale = 1
//        }
    }
    
    @objc func pan(gestureRecognizer gesture : UIPanGestureRecognizer){
        if (gesture.view as! UIScrollView).zoomScale > (gesture.view as! UIScrollView).zoomScale {
            isZoomedIn = true
        } else {
            isZoomedIn = false
        }
//        let translation = gesture.translation(in: self.view)
//        if let view = gesture.view {
//            view.center = CGPoint(x:view.center.x + translation.x,
//                                  y:view.center.y + translation.y)
//        }
//        gesture.setTranslation(CGPoint.zero, in: self.view)
    }

    @objc func longPress(gestureRecognizer gesture : UILongPressGestureRecognizer) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeGroceryList(_ sender: Any) {
        dismiss(animated: false, completion:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
