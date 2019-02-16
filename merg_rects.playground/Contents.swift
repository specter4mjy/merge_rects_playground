//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
        
        let rect = UIView()
        rect.backgroundColor = .red
        rect.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        view.addSubview(rect)
        
        let rect2 = UIView()
        rect2.backgroundColor = .green
        rect2.frame = CGRect(x: 80, y: 20, width: 20, height: 20)
        view.addSubview(rect2)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
