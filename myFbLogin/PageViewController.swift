//
//  PageViewController.swift
//  myFbLogin
//
//  Created by Raghav Nyati on 12/12/16.
//  Copyright © 2016 Raghav Nyati. All rights reserved.
//

import UIKit
import UIKit

class PageViewController: UIPageViewController
{
    var pageHeaders = ["Get your Restaurant App designed", "Give Prototypes", "Get an iOS App", "Social Networks with Parse"]
    var pageImages = ["app1", "app2", "app3", "app4"]
    var pageDescriptions = ["Get the world's most beautiful iOS app for your Restaurant without having to hire a designer.", "Validate your app idea by creating and providing a prototype before implementation", "Delight your users with stunning animation and transition", "Connect people together!"]
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this class is the page view controller's data source itself
        self.dataSource = self
        
        // create the first walkthrough vc
        if let startWalkthroughVC = self.viewControllerAtIndex(0) {
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Navigate
    
    func nextPageWithIndex(_ index: Int)
    {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index+1) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> WalkthroughViewController?
    {
        if index == NSNotFound || index < 0 || index >= self.pageDescriptions.count {
            return nil
        }
        
        // create a new walkthrough view controller and assing appropriate date
        if let walkthroughViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            walkthroughViewController.imageName = pageImages[index]
            walkthroughViewController.headerText = pageHeaders[index]
            walkthroughViewController.descriptionText = pageDescriptions[index]
            walkthroughViewController.index = index
            
            return walkthroughViewController
        }
        
        return nil
    }
}

extension PageViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
}

