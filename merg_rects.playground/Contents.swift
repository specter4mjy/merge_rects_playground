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
                     CGRect(x: 70, y: 30, width: 20, height: 20),
                     CGRect(x: 30, y: 180, width: 20, height: 20),
                     CGRect(x: 30, y: 150, width: 20, height: 20)]
        
        show(rects: rects, offsetY: 0)
        
        //        let sortedRects = sortWithMinX(rects: rects)
        let sortedRects = sort(rects: rects, with: .Y)
        
        print("sortedRects", sortedRects)
        
        let mergedRects = sortedRects.flatMap { merge(rects: $0, with: .X) }
        print("mergedRects", mergedRects)
        
        show(rects: mergedRects, offsetY: 300)
        
        return
    }
    
    enum Direction {
        case X
        case Y
        
        var opposite: Direction {
            switch self {
            case .X:
                return .Y
            case .Y:
                return .X
            }
        }
        
        func minValue(r: CGRect) -> CGFloat {
            switch self {
            case .X:
                return r.minX
            case .Y:
                return r.minY
            }
        }
        
        func maxValue(r: CGRect) -> CGFloat {
            switch self {
            case .X:
                return r.maxX
            case .Y:
                return r.maxY
            }
        }
        
        func canMerge(a: CGRect, b: CGRect) -> Bool {
            if opposite.minValue(r: a) == opposite.minValue(r: b) &&
                opposite.maxValue(r: a) == opposite.maxValue(r: b) &&
                (maxValue(r: a) == minValue(r: b) || minValue(r: a) == maxValue(r: b)) {
                return true
            } else {
                return false
            }
        }
    }
    
    func sort(rects: [CGRect], with direction: Direction) -> [[CGRect]] {
        var result = [[CGRect]]()
        
        let values = rects.map(direction.minValue)
        
        let uniqueValues = Array(Set(values))
        let sortedUniqueValues = uniqueValues.sorted()
        
        sortedUniqueValues.forEach { v in
            let rectsWithV = rects.filter { direction.minValue(r: $0) == v }
            result.append(rectsWithV)
        }
        
        return result
    }
    
    func merge(rects: [CGRect], with direction: Direction) -> [CGRect] {
        var results = rects
        
        results = rects.sorted { a, b in
            direction.minValue(r: a) < direction.minValue(r: b)
        }
        
        var i = 0
        var j = 1
        
        while j < rects.count {
            let rectA = results[i]
            let rectB = results[j]
            
            if direction.canMerge(a: rectA, b: rectB) {
                print(direction.canMerge(a: rectA, b: rectB), rectA, rectB)
                let minX = min(rectA.minX, rectB.minX)
                let minY = min(rectA.minY, rectB.minY)
                let maxX = max(rectA.maxX, rectB.maxX)
                let maxY = max(rectA.maxY, rectB.maxY)
                
                let mergedRect = CGRect(x: minX, y: minX, width: maxX - minX, height: maxY - minY)
                print(mergedRect)
                
                results.append(mergedRect)
                
                results.remove(at: i)
                results.remove(at: j - 1)
                return merge(rects: results, with: direction)
            } else {
                i = i + 1
                j = j + 1
            }
        }
        
        return results
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
