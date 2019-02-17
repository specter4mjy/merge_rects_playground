//
//  ViewController.swift
//  merge_rects
//
//  Created by Jony Ma on 2/17/19.
//  Copyright © 2019 com.jony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rects: [CGRect] = [
            CGRect(x: 30 , y: 30 , width: 20, height: 20),
            CGRect(x: 60 , y: 30 , width: 20, height: 20),
            CGRect(x: 80 , y: 30 , width: 20, height: 20),
            CGRect(x: 110, y: 30 , width: 20, height: 20),
            CGRect(x: 130, y: 30 , width: 20, height: 20),
            CGRect(x: 180, y: 30 , width: 20, height: 20),
            CGRect(x: 30 , y: 50 , width: 20, height: 20),
            
            CGRect(x: 30 , y: 100, width: 20, height: 20),
            CGRect(x: 30 , y: 120, width: 20, height: 20),
            CGRect(x: 50 , y: 120, width: 20, height: 20),
            CGRect(x: 30 , y: 140, width: 20, height: 20),
            
            CGRect(x: 30 , y: 180, width: 20, height: 20),
            CGRect(x: 50 , y: 180, width: 20, height: 20),
            CGRect(x: 50 , y: 200, width: 20, height: 20),
            CGRect(x: 30 , y: 200, width: 20, height: 20),
            ]
        
        show(rects: rects, offsetY: 100)
        
        let sortedXRects = sort(rects: rects, with: .Y)
        
        let mergedXRects = sortedXRects.flatMap { merge(rects: $0, with: .X) }
        
        show(rects: mergedXRects, offsetY: 350)
        
        let sortedYRects = sort(rects: rects, with: .X)
        let mergedYRects = sortedYRects.flatMap { merge(rects: $0, with: .Y) }
        show(rects: mergedYRects, offsetY: 600)
        
        let sortedAllRects = sort(rects: mergedXRects, with: .X)
        let mergedAllRects = sortedAllRects.flatMap { merge(rects: $0, with: .Y) }
        show(rects: mergedAllRects, offsetY: 850)
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
            return opposite.minValue(r: a) == opposite.minValue(r: b) &&
                opposite.maxValue(r: a) == opposite.maxValue(r: b) &&
                (maxValue(r: a) == minValue(r: b) || minValue(r: a) == maxValue(r: b))
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
                let minX = min(rectA.minX, rectB.minX)
                let minY = min(rectA.minY, rectB.minY)
                let maxX = max(rectA.maxX, rectB.maxX)
                let maxY = max(rectA.maxY, rectB.maxY)
                
                let mergedRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                
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
        func addSeparator(offsetY: CGFloat) {
            let separator = UIView()
            separator.frame = CGRect(x: 0, y: offsetY, width: view.bounds.width, height: 1)
            separator.backgroundColor = .black
            view.addSubview(separator)
        }
        addSeparator(offsetY: offsetY)
        
        var hue: CGFloat = 0
        rects.forEach { rect in
            hue = hue + 0.08
            
            let r = rect.offsetBy(dx: 0, dy: offsetY)
            let v = UIView(frame: r)
            v.backgroundColor = UIColor(hue: hue, saturation: 0.9, brightness: 0.9, alpha: 1)
            view.addSubview(v)
        }
    }
}

