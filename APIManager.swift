//
//  APIManager.swift
//  APIManager Class
//
//  Created by Pushpank Kumar on 21/01/19.
//  Copyright © 2019 Pushpank Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager {
    
    //create singleton Class Object
    static let shared = APIManager()
    
    private init() {
        
        // Do nothing here...
    }
    
    // Completion Handler
    typealias webServiceResponse = (JSON?, Error?) -> Void
    
    // MARK: Get Service Function
    func getService (getUrl: String, completionHandler : @escaping (JSON?, Error?) -> ()) {
      
        // If Url is not valid 
        guard let url = URL(string: getUrl) else {
            print("Error: cannot create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("this is the error \(String(describing: error))")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let json = JSON(responseData)
            completionHandler(json, error)
        }
        task.resume()
    }
    
    
    
    // MARK: Post service function
    func postService (postUrl: String, dict: [String:Any], completionHandler: @escaping webServiceResponse ) {
       
        let Url = String(format: postUrl)
        
        // Url Validate 
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        
        // Set http method type 
        request.httpMethod = "POST"
        
        // Set Header Type 
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                                         
            if let response = response {
                print("response is ",response)
            }
                                         
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    // convert objects in json objects 
                    let jsonPayload = JSON(json)
                    // if you get the data, callback on the model call 
                    completionHandler(jsonPayload, nil)
                    print("JSON Serialization **** ",json)
                } catch {
                    print("error is *** ",error)
                    // If you get the error, callback with error in model class
                    completionHandler(nil, error)
                }
            }
            }.resume()
    }
}





















//
//  GetStartedVC1.swift
//  MrCanvas
//
//  Created by Mayank Singh on 09/03/19.
//  Copyright © 2019 Kumar. All rights reserved.
//

import UIKit

class GetStartedVC1: UIPageViewController {
    
    
    var pageControl : UIPageControl = UIPageControl()
    var nextButton = UIButton()
    
    var index = 0
    
    lazy var viewControllerArray: [UIViewController] = {
        return [
            
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RedViewController") as! RedViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GreenViewController") as! GreenViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VoiletViewController") as! VoiletViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SyncAccountVC") as! SyncAccountVC,
            ]
    }()
    

    


    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        setViewControllers([viewControllerArray[0]], direction: .forward, animated: true, completion: nil)
        
        nextButtonSetUp()
        configurePageControl()

    }
    
    
    func nextButtonSetUp()  {
        
        self.view.addSubview(nextButton)
        
        nextButton.backgroundColor = .red
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
    }
    
    
    @objc func buttonClicked() {
        print("Button Clicked")
        
        slideToPage()
        
    }

    
    func configurePageControl() {
        
        self.pageControl.numberOfPages = viewControllerArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = .black
        self.pageControl.currentPageIndicatorTintColor = .green
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    func slideToPage()  {
        
        if index < viewControllerArray.count-1 {
            
            index = index + 1
            
            let pageControlIndex = index
            pageControl.currentPage = pageControlIndex
            self.setViewControllers([viewControllerArray[pageControlIndex]], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
}



extension GetStartedVC1: UIPageViewControllerDataSource {
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return viewControllerArray.count
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = viewControllerArray.index(of:viewController) ?? 0
        
        if currentIndex <= 0 {
            
            index = currentIndex
            
            pageControl.currentPage = index
            return nil
        }
        
        pageControl.isHidden = false

        
        index = currentIndex
        pageControl.currentPage = index
        return viewControllerArray[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = viewControllerArray.index(of:viewController) ?? 0
        index = currentIndex
        pageControl.currentPage = index
        
        if currentIndex >= viewControllerArray.count-1 {
            
            pageControl.isHidden = true
            nextButton.isHidden = true
            
            
            return nil
        }
        
        print("Current Index \(currentIndex)")
        
        return viewControllerArray[currentIndex + 1]
    }
    
}




//////////// Scroll Slider 











//
//  ViewController.swift
//  MrCanvas
//
//  Created by Mayank Singh on 09/03/19.
//  Copyright © 2019 Kumar. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "2")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "3")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
       
    }


}

private typealias ScrollView = GetStartedVC
extension ScrollView : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        //        if Int(currentPage) == 0{
        //            textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        //        }else if Int(currentPage) == 1{
        //            textView.text = "I write mobile tutorials mainly targeting iOS"
        //        }else if Int(currentPage) == 2{
        //            textView.text = "And sometimes I write games tutorials about Unity"
        //        }else{
        //            textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
        //            // Show the "Let's Start" button in the last slide (with a fade in animation)
        //            UIView.animate(withDuration: 1.0, animations: { () -> Void in
        //                self.startButton.alpha = 1.0
        //            })
        //        }
    }
}











