//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.backgroundColor = .black
        self.view = view
        
        let rects = [CGRect(x: 30, y: 30, width: 20, height: 20),
                     CGRect(x: 50, y: 30, width: 20, height: 20),
                     CGRect(x: 30, y: 80, width: 20, height: 20),
                     CGRect(x: 30, y: 150, width: 20, height: 20)]
        
        rects.forEach { rect in
            let v = UIView(frame: rect)
            v.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 1, brightness: 1, alpha: 1)
            view.addSubview(v)
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
