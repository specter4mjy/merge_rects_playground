//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    let canvas = UIView()
    
    override func loadView() {
        canvas.backgroundColor = .white
        canvas.backgroundColor = .black
        self.view = canvas
        
        let rects = [CGRect(x: 30, y: 30, width: 20, height: 20),
                     CGRect(x: 50, y: 30, width: 20, height: 20),
                     CGRect(x: 30, y: 80, width: 20, height: 20),
                     CGRect(x: 30, y: 150, width: 20, height: 20)]
        
        show(rects: rects, offsetY: 0)

//        let sortedRects = sortWithMinX(rects: rects)
        let sortedRects = sort(rects: rects, with: .Y)
        
        print(sortedRects)
        
        return
    }
    
    enum Direction {
        case X
        case Y
    }
    
    func sort(rects: [CGRect], with direction: Direction) -> [[CGRect]] {
        func wantedValue(r: CGRect) -> CGFloat {
            switch direction {
            case .X:
                return r.minX
            case .Y:
                return r.minY
            }
        }
        
        var result = [[CGRect]]()
    
        let values = rects.map(wantedValue)

        let uniqueValues = Array(Set(values))
        let sortedUniqueValues = uniqueValues.sorted()
        
        sortedUniqueValues.forEach { v in
            let rectsWithV = rects.filter { wantedValue(r: $0) == v }
            result.append(rectsWithV)
        }
        
        return result
    }
    
    func show(rects: [CGRect], offsetY: CGFloat) {
        var hue: CGFloat = 0
        rects.forEach { rect in
            hue = hue + 0.2
            
            let r = rect.offsetBy(dx: 0, dy: offsetY)
            let v = UIView(frame: r)
            v.backgroundColor = UIColor(hue: hue, saturation: 0.9, brightness: 0.9, alpha: 1)
            canvas.addSubview(v)
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
