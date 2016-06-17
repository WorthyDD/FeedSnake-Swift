//
//  ViewController.swift
//  FeedSnake
//
//  Created by 武淅 段 on 16/6/16.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgHeight: NSLayoutConstraint!
    @IBOutlet weak var bgWidth: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var timer : NSTimer!
    var bodys = NSMutableArray()
    var direction : Direction = .DOWN
    let w : CGFloat = 20.0
    var food : BodyView!
    var score : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBgView()
        self.initSnake()
        self.generateFood()
        self.run()
        
    }

    func initBgView(){
        if UIScreen.mainScreen().bounds.size.width < 330{
            bgWidth.constant = 300
            bgHeight.constant = 400
        }
        else if UIScreen.mainScreen().bounds.size.width<400{
            bgWidth.constant = 360
            bgHeight.constant = 480
        }
        else{
            bgWidth.constant = 400
            bgHeight.constant = 600
        }
    }
    func initSnake(){
        
        let head = BodyView()
        head.backgroundColor = UIColor.redColor()
        head.frame = CGRectMake(0, 0, w, w)
        head.layer.borderColor = UIColor.blackColor().CGColor
        head.layer.borderWidth = 1
        bgView.addSubview(head)
        bodys.addObject(head)
    }

    func run(){
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.move(_:)), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func move(timer : NSTimer){
        print("move:\(direction)")
        //找到尾巴, 挪动到头部
        let head = bodys.firstObject as! BodyView
        let tail = bodys.lastObject as! BodyView
        var x : CGFloat = head.center.x
        var y : CGFloat = head.center.y
        switch direction {
        case .UP:
            y = y-w
            break
        case .DOWN:
            y = y+w
            break
        case .LEFT:
            x = x-w
            break
        case .RIGHT:
            x = x+w
            break
        }
        if x<w/2 || x > CGRectGetWidth(bgView.frame)-w/2 || y < w/2 || y > CGRectGetHeight(bgView.frame)-w/2{
            //die
            timer.invalidate()
            return
        }
        
        //检测有没有咬尾
        for body in bodys{
            let b = body as! BodyView
            if b.center.x == x && b.center.y == y{
                timer.invalidate()
                return
            }
        }
        
        //检测食物碰撞
        if food != nil && food.center.x == x && food.center.y == y{
            //尾巴加长
            let tem = BodyView()
            tem.backgroundColor = UIColor.redColor()
            tem.frame = CGRectMake(0, 0, w, w)
            tem.center = CGPointMake(x, y)
            tem.layer.borderColor = UIColor.blackColor().CGColor
            tem.layer.borderWidth = 1
            tem.direction = direction
            tem.backgroundColor = UIColor.lightGrayColor()
            bgView.addSubview(tem)
            bodys.insertObject(tem, atIndex: 0)
            food.removeFromSuperview()
            food = nil
            score += 1
            self.scoreLabel.text = "分数: \(score)"
            self.generateFood()
            for i in 1 ..< bodys.count{
                let body = bodys[i] as! BodyView
                body.backgroundColor = UIColor.redColor()
            }
        }
        else{
            //尾巴移到头部
            tail.direction = direction
            tail.center = CGPointMake(x, y)
            tail.backgroundColor = UIColor.lightGrayColor()
            bodys.insertObject(tail, atIndex: 0)
            bodys.removeObject(tail)
            bodys.insertObject(tail, atIndex: 0)
            for i in 1 ..< bodys.count{
                let body = bodys[i] as! BodyView
                body.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    func generateFood(){
        
        var x : CGFloat = 0.0
        var y : CGFloat = 0.0
        let w1 = Int32(CGRectGetWidth(bgView.frame)/w)
        let h1 = Int32(CGRectGetHeight(bgView.frame)/w)
        x = CGFloat(rand()%Int32(w1))*w+w/2
        y = CGFloat(rand()%Int32(h1))*w+w/2
        for body in bodys{
            let b = body as! BodyView
            if b.center.x == x && b.center.y == y{
                self.generateFood()
                return
            }
        }
        let f = BodyView()
        f.frame = CGRectMake(0, 0, w, w)
        f.center = CGPointMake(x, y)
        f.backgroundColor = UIColor.greenColor()
        f.layer.borderColor = UIColor.blackColor().CGColor
        f.layer.borderWidth = 1
        food = f
        bgView.addSubview(f)
    }
    
    
    @IBAction func tapUp(sender: AnyObject) {
        let head = bodys.firstObject as! BodyView
        if head.direction == .LEFT || head.direction == .RIGHT{
            direction = .UP
        }
    }
    @IBAction func tapDown(sender: AnyObject) {
        let head = bodys.firstObject as! BodyView
        if head.direction == .LEFT || head.direction == .RIGHT{
            direction = .DOWN
        }
    }
       
    @IBAction func tapLeft(sender: AnyObject) {
        let head = bodys.firstObject as! BodyView
        if head.direction == .UP || head.direction == .DOWN{
            direction = .LEFT
        }
    }
    @IBAction func tapRight(sender: AnyObject) {
        let head = bodys.firstObject as! BodyView
        if head.direction == .UP || head.direction == .DOWN{
            direction = .RIGHT
        }
    }
    @IBAction func restart(sender: AnyObject) {
        food.removeFromSuperview()
        for body in bodys{
            let b = body as! BodyView
            b.removeFromSuperview()
        }
        timer.invalidate()
        timer = nil
        direction = .DOWN
        bodys.removeAllObjects()
        self.initSnake()
        self.generateFood()
        self.run()
    }
}

