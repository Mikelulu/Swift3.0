//
//  ViewController.swift
//  Swift_黑魔法swizzle
//
//  Created by Riches on 2016/10/29.
//  Copyright © 2016年 Riches. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button = UIButton.init(frame: CGRect(x:10, y:100, width:self.view.frame.size.width - 20, height:40))
        button?.backgroundColor = UIColor.lightGray
        UIButton.swip()
        self.view.addSubview(button!)
        button?.addTarget(self, action: #selector(tap(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func tap(_ button: UIButton) {
        print("您好")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIButton {
    class func swip() {
        // 创建一个结构体，写个静态常量
        struct T {
            static let x: Bool = {
                let cls: AnyClass = UIButton.self
                // 创建消息对象
                let originalSelector = #selector(UIButton.sendAction(_:to:for:))
                let swizzleSelector = #selector(UIButton.swizzle_sendAction(action:to:forEvent:))
                // 创建方法
                let ori_method = class_getInstanceMethod(cls, originalSelector)
                let swi_method = class_getInstanceMethod(cls, swizzleSelector)
                
                print(ori_method)
                print(swi_method)
                // 交换两个方法的实现部分
                method_exchangeImplementations(ori_method, swi_method)
                print("执行。。。。。。。。。")
                return false
            }()
        }
        // 这里必须执行一下,不然没法创建静态变量
        T.x
    }
    // 定义要交换的函数
    public func swizzle_sendAction(action: Selector, to: AnyClass!, forEvent: UIEvent!) {
        // 定义一个累加器
        struct button_tap_count {
            static var count = 0
        }
        button_tap_count.count += 1
        print(button_tap_count.count)
        // 看似好像调用了自己构成死循环,但是 我们其实已经将两个方法名的实现进行了调换 所以 其实我们调用的是 方法sendAction:to:forEvent 的实现 这样就可以在不破坏原先方法结构的基础上进行交换实现
        swizzle_sendAction(action: action, to: to, forEvent: forEvent)
    }
}














