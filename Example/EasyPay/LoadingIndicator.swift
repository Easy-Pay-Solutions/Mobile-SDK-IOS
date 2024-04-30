
import UIKit

class LoadingIndicator {
    static let kLoadingContainerTag = 9022021
    static let kContainerSide : CGFloat = 60.0
    static var counter = 0
    
    class func showLoadingIndicator(){
        counter += 1
        let window = UIApplication.shared.windows.first
        var container = window?.viewWithTag(kLoadingContainerTag)
        container?.isHidden = false
        if (container != nil)  {
            window?.isUserInteractionEnabled = false
            window?.bringSubviewToFront(container!)
            return
        }
        let rc = CGRect(x:0, y:0, width: kContainerSide, height: kContainerSide)
        
        let loadIndicator = UIActivityIndicatorView.init(frame: rc)
        
        loadIndicator.hidesWhenStopped = true
        loadIndicator.style = UIActivityIndicatorView.Style.large
        loadIndicator.color = .white
        
        container = UIView.init(frame: rc)
        container?.layer.cornerRadius = 10.0
        container?.center = (window?.center)!
        container?.backgroundColor = .gray
        container?.addSubview(loadIndicator)
        
        
        let coverView = UIView.init(frame: (window?.bounds)!)
        coverView.backgroundColor = UIColor.clear
        coverView.tag = kLoadingContainerTag
        coverView.addSubview(container!)
    
        window?.addSubview(coverView)
        loadIndicator.startAnimating()
        window?.isUserInteractionEnabled = false
    }
    
    class func hideLoadingIndicator(){
        counter -= 1
        for window in UIApplication.shared.windows {
            if let v = window.viewWithTag(kLoadingContainerTag){
                v.removeFromSuperview()
                window.isUserInteractionEnabled = true
            }
        }
    }
}
