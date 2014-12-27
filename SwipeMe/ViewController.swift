//
//  ViewController.swift
//  SwipeMe
//
//  Created by Steven Gibson on 12/21/14.
//  Copyright (c) 2014 OakmontTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // bottom layer
    @IBOutlet weak var baseView: UIView!
    //view that comes from bottom layer
    @IBOutlet weak var dummyView: UIView!
    // first official view for user
    @IBOutlet weak var bottomCardView: UIView!
    // top card shown to user
    @IBOutlet weak var topCardView: UIView!
    // label on top card... could customize card to have more elements
    @IBOutlet weak var topViewLabel: UILabel!
    // bottom card label...what ever elements need to match the top card exactly
    @IBOutlet weak var bottomCardLabel: UILabel!
    
    // all of our custom properties
    var customView = CardView.loadFromNibNamed("CardView")
    
    // I need this to keep track for animations
    var topOrginalCenter = CGPoint()
    var topOriginalBounds = CGRect()
    var bottomOriginalCenter = CGPoint()
    var bottomOriginalBounds = CGRect()
    var dummyOriginalCenter = CGPoint()
    var dummyOriginalBounds = CGRect()
    var baseOriginalBounds = CGRect()
    var baseOriginalCenter = CGPoint()
    
    // activity indicatorview ->Spinner Fun
    var activity = UIActivityIndicatorView()
    
    // Float to keep track of the vertical difference between views.  Views must be equally spaced
    // in storybard
    var difference = CGFloat()
    
    // these are for our tossing views
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var pushBehavior : UIPushBehavior!
    var itemBehavior : UIDynamicItemBehavior!
    
   
    // top cardview color
    let topColor: UIColor = UIColor( red: CGFloat(240/255.0), green: CGFloat(240/255.0), blue: CGFloat(240/255.0), alpha: CGFloat(1.0) )
    // used in animation to topcolor to make it not so drastic
    let almosttopColor: UIColor = UIColor( red: CGFloat(237/255.0), green: CGFloat(237/255.0), blue: CGFloat(237/255.0), alpha: CGFloat(1.0) )
    // dummyview will animate to almost second then finally second view color
    let almostSecondColor: UIColor = UIColor( red: CGFloat(232/255.0), green: CGFloat(232/255.0), blue: CGFloat(232/255.0), alpha: CGFloat(1.0) )
    // bottom Card Color
    let secondLayerColor: UIColor = UIColor( red: CGFloat(235/255.0), green: CGFloat(235/255.0), blue: CGFloat(235/255.0), alpha: CGFloat(1.0) )
    // dummyView Color which also matches the baseView
    let thirdLayerColor: UIColor = UIColor( red: CGFloat(230/255.0), green: CGFloat(230/255.0), blue: CGFloat(230/255.0), alpha: CGFloat(1.0) )
    // baseView color
    let fourthLayerColor: UIColor = UIColor( red: CGFloat(230/255.0), green: CGFloat(230/255.0), blue: CGFloat(230/255.0), alpha: CGFloat(1.0) )

    // pushing Views static
    let ThrowingThreshold : CGFloat = 1000.0
    let ThrowingvelocityPadding: CGFloat = 35.0
    var panGesture : UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // dataSource Array
    var dataStrings : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        /******This is for an alternative animation with only two cards *******/
        /******Uncomment below but comment out the set up our cards just below that to use this***/
        //self.setUpSlidingView()
        
        
        //set up our cards make sure above is commented out if using this and vice versa
        //this is to make it look like a deck of cards coming to the top  
        //calling the basic setup
        self.setUpCardView()
        
        //Set up our animator that will be needed to toss
        animator = UIDynamicAnimator(referenceView: view)
        
        // this does not have to be here and would be added even if you delete it here
        self.dataStrings = ["This has been fun to build\r~Alex Gibson","I have a couple of other animation that I came up with by working on this\r~Alex Gibson","If you find a way to improve this please let me know\r~Alex Gibson", "The fun of programming never stops.\r~Alex Gibson","This was fun to mess around with for a bit\r~Alex Gibson","I have figured out that things that took a long time to build before, only take a short time now\r~Alex Gibson","Have I mentioned that I like Objective C but I am learning Swift\r~Alex Gibson","Swift is great until you have to parse a JSON or do math\r~Alex Gibson","I like dot notation but I miss brackets and dot notation for setters and getters\r~Alex Gibson","Getting Tired of typing\r~Alex Gibson"]

    }
    
    func setUpCardView(){
        
        //hide the animation button for single slide example that is commented out
        self.animateButton.hidden = true
        
        // find the difference between the cards for animations and set our property
        difference = self.dummyView.frame.origin.y - self.bottomCardView.frame.origin.y

        //round off the corners and scale to make the bottom smaller
        self.baseView.layer.cornerRadius = 10
        self.baseView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        // card that will move off base layer
        self.dummyView.layer.cornerRadius = 10
        self.dummyView.transform = CGAffineTransformMakeScale(0.8, 0.8)

        // card just below top view
        self.bottomCardView.layer.cornerRadius = 10
        self.bottomCardView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        //top card and with a scale of 1,1
        self.topCardView.layer.cornerRadius = 10
        
        // add our pangesture to toss the cards away
        panGesture = UIPanGestureRecognizer(target: self, action: "panGestureDidPan:")
        topCardView.addGestureRecognizer(panGesture)
 
        
        // save our original center and bounds
        // this is good to keep track of all of the animations and to reset
        topOriginalBounds = topCardView.bounds
        topOrginalCenter = topCardView.center
        
        bottomOriginalBounds = bottomCardView.bounds
        bottomOriginalCenter = bottomCardView.center
        
        dummyOriginalBounds = dummyView.bounds
        dummyOriginalCenter = dummyView.center
        
        baseOriginalBounds = baseView.bounds
        baseOriginalCenter = baseView.center
        
        
        // get setup // this could also call a data task and show an activity view
        self.resetViewsAndNewData()
        
        
    }

    
    // this method is only in the slide example not in the stack of cards
    func setUpSlidingView(){
      
        dummyView.removeFromSuperview()
        bottomCardView.removeFromSuperview()
        topCardView.removeFromSuperview()
        
        //now the real setup
        customView!.frame = self.baseView.frame
        customView?.frame.origin.y = self.baseView.frame.origin.y - 10
        customView!.layer.cornerRadius = 10
        
        self.view.addSubview(customView!)
    
    }
    
   
    // handle the pan Gesture
    func panGestureDidPan(sender:UIPanGestureRecognizer)
    {
        //get the view that is panning//should be the top cardView
        let panningView : UIView = sender.view!
        // location in the view
        let location = sender.locationInView(self.view);
        // location in the panning view
        let boxLocation = sender.locationInView(sender.view)
        // get offset
        let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(panningView.bounds), boxLocation.y - CGRectGetMidY(panningView.bounds));
        
        if sender.state == UIGestureRecognizerState.Began
        {
            animator.removeAllBehaviors()

            // animate cards forward to make it look like the user has a new card from deck
            animateTheCardsForward()
            
            
            attachmentBehavior = UIAttachmentBehavior(item: panningView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
            
            // if swiping left turn red
            if location.x < self.view.center.x
            {
                self.topCardView.backgroundColor = UIColor.redColor()
            }
            // if swipping right turn green
            else if location.x > self.view.center.x
            {
                self.topCardView.backgroundColor = UIColor.greenColor()
            }
            // middle just top cardView color
            else
            {
                self.topCardView.backgroundColor = topColor
            }
            
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            // get the velocity
            let velocity : CGPoint = sender.velocityInView(self.view)
            // magnitude
            var addition = (velocity.x * velocity.x) + (velocity.y * velocity.y)
            var final = sqrtf(Float(addition))
            let magnitude : CGFloat = CGFloat(final)
            
            // if the magnitude is high enough we will throw the card off the screen
            if magnitude > ThrowingThreshold {
                animator.removeAllBehaviors()
                let pushBehavior : UIPushBehavior = UIPushBehavior(items: [panningView], mode: UIPushBehaviorMode.Instantaneous)
                pushBehavior.pushDirection = CGVectorMake(velocity.x/10, velocity.y/10)
                pushBehavior.magnitude = magnitude / ThrowingvelocityPadding
                
                self.pushBehavior = pushBehavior
                self.animator.addBehavior(self.pushBehavior)
                
                let angle : NSInteger = arc4random_uniform(20)-10
                
                self.itemBehavior = UIDynamicItemBehavior(items: [panningView])
                self.itemBehavior.friction = 0.2
                self.itemBehavior.allowsRotation = true
                self.itemBehavior.addAngularVelocity(CGFloat(angle), forItem: panningView)
                self.animator .addBehavior(self.itemBehavior)

                // finish the color change and call all the resets
                self.finishAnimationAndReset()
                
                
            }
            // animate the cards back in place because it was not swiped hard enough
            else
            {
                
                self.animateTheCardsBack()
                
            }
        }
    }
    

    //if the card has been thrown off the screen we want to match the colors up and remove the object
    func finishAnimationAndReset()
    {
        // animate the colors all of the way before we reset the view
        UIView.animateWithDuration(0.1, animations: {
            
            self.bottomCardView.backgroundColor = self.topColor
            self.dummyView.backgroundColor = self.secondLayerColor
            
            }, completion: {(finished :Bool)in
 
                    self.delay(0.27, closure: {
                        
                        if self.dataStrings.count>0
                        {
                        self.dataStrings.removeAtIndex(0)
                        }
                        self.resetViewsAndNewData()
                        
                    })

        })
        
        

    }
  
    
    // simply scale and move closer to the user
    func animateTheCardsForward()
    {

        if self.dataStrings.count>0{
        
        let translate : CGAffineTransform = CGAffineTransformMakeTranslation(0, -difference)
   
        UIView.animateWithDuration(0.3, animations: {
           //move dummyView off the bottom layer and bottom card to top
            
            self.dummyView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.dummyView.backgroundColor = self.almostSecondColor
            self.dummyView.bounds = self.bottomOriginalBounds
            self.dummyView.center = self.bottomOriginalCenter
            
            self.bottomCardView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.bottomCardView.backgroundColor = self.almosttopColor
            self.bottomCardView.bounds = self.topOriginalBounds
            self.bottomCardView.center = self.topOrginalCenter
            
        })
        }
        
        
    }
   
    // animate the cards back in place
    func animateTheCardsBack()
    {

        // move The cards back to the original postion for 3 cards
        
            UIView.animateWithDuration(0.25, animations: {
                self.dummyView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                self.dummyView.backgroundColor = self.thirdLayerColor
                self.dummyView.bounds = self.dummyOriginalBounds
                self.dummyView.center = self.dummyOriginalCenter
                
                self.bottomCardView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                self.bottomCardView.backgroundColor = self.secondLayerColor
                self.bottomCardView.bounds = self.bottomOriginalBounds
                self.bottomCardView.center = self.bottomOriginalCenter
                
                // snap card back into place with animation
                self.topCardView.transform = CGAffineTransformIdentity
                self.topCardView.backgroundColor = self.topColor
                self.topCardView.bounds = self.topOriginalBounds
                self.topCardView.center = self.topOrginalCenter
                },completion: {
                    (value: Bool) in
                    // we do not need this completion
                    //println("Finished Snapping Back")
                    
                })

        
    }

    
    
    // this is used in our two card sliding example but not in the stack of cards
    @IBAction func animateDidPress(sender: AnyObject) {

        //This is for our sliding view
        var findTranslate = 10 + self.customView!.frame.size.height
        
        // This sucks to to do this
        var view: AnyObject? = self.view?.subviews.last
        
        if ((view as UIView) == customView){
            println("This is a test")
            var y = self.baseView.frame.origin.y as CGFloat
            
            
            
            var translate = CGAffineTransformMakeTranslation(0, -findTranslate);
            UIView.animateWithDuration(0.5, animations: {
                self.customView!.transform = translate
                
                },completion: {
                    (value: Bool) in
                    UIView.animateWithDuration(0.5, animations: {
                        self.view .sendSubviewToBack(self.customView!)
                        self.customView?.transform = CGAffineTransformIdentity
                    })
            })
            return
        }
        else {
            var translate = CGAffineTransformMakeTranslation(0, -findTranslate);
            UIView.animateWithDuration(0.5, animations: {
                self.customView!.transform = translate
                },completion: {
                    (value: Bool) in
                    UIView.animateWithDuration(0.5, animations: {
                        self.view.bringSubviewToFront(self.customView!)
                        self.customView?.transform = CGAffineTransformIdentity
                    })
            })
            return
        }
    }
    

    
    // reset our views to get them ready for animation again and load new data
    func resetViewsAndNewData()
    {
        
        if self.animator != nil
        {
            self.animator .removeAllBehaviors()
        }
        
        
        self.topCardView.transform = CGAffineTransformIdentity
        self.topCardView.bounds = self.topOriginalBounds
        self.topCardView.center = self.topOrginalCenter
        self.topCardView.backgroundColor = self.topColor
        
        //self.bottomCardView.transform = CGAffineTransformIdentity
        self.bottomCardView.transform = CGAffineTransformMakeScale(0.90, 0.90)
        self.bottomCardView.bounds = bottomOriginalBounds
        self.bottomCardView.center = bottomOriginalCenter
        self.bottomCardView.backgroundColor = self.secondLayerColor
        
        
        self.dummyView.transform = CGAffineTransformMakeScale(0.80, 0.80)
        self.dummyView.bounds = dummyOriginalBounds
        self.dummyView.center = dummyOriginalCenter
        self.dummyView.backgroundColor = self.baseView.backgroundColor
        
        self.baseView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.baseView.bounds = self.baseOriginalBounds
        self.baseView.center = self.baseOriginalCenter
        
        
        // if the count is more than 1 we set the top and bottom cards with array
        if self.dataStrings.count > 1
        {
            self.topViewLabel?.text = self.dataStrings[0] as String
            self.bottomCardLabel?.text = self.dataStrings[1] as String
            self.topCardView.alpha = 1
        }
        // if the count is equal to 1 set the top label with array
        // the other label is generic text "There are currently no more cards"
        // if we set the bottom label with the data array it would be OUT OF BOUNDS
        else if self.dataStrings.count==1
        {
            self.topViewLabel?.text = self.dataStrings[0] as String
            self.bottomCardLabel!.text = "There are currently no more cards"
            self.topCardView.alpha = 1
            
        }
        
        // cards are gone so load from datasource/json
        // remember we would normally just call a dataTask but we are doing this for show to make it
        // look like we are calling a dataTask
        else
        {
            // No cards left
            
            self.topViewLabel?.text = "There are currently no more cards"
            // remove the gesture so the user cannot do anything
            self.topCardView.removeGestureRecognizer(panGesture)
            self.topCardView.alpha = 1
            
            //here is an activiy view if we were downloading just for demonstration but not necessary
            self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            activity.center = self.view.center
            activity.alpha = 0;
            
            // added to view but not animating
            self.view.addSubview(activity)
            
            
            
            
            // we are going to animate our cards off the view then back on just for effect 
            // using a delay here to show an activityView
            self.delay(0.5, closure: {
                var translate = CGAffineTransformMakeTranslation(0,self.view.frame.size.height);
               
                UIView.animateWithDuration(0.4, animations: {
                    
                    //move our cards off the screen
                    self.topCardView.transform = translate
                    self.bottomCardView.transform = translate
                    self.dummyView.transform = translate
                    self.baseView.transform = translate
                    
                    //make activity view visible
                    self.activity.alpha = 1
                    
                    
                    }, completion: {(value:Bool)in
                        // Ensure we are on the main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // start the activity view animation
                            self.activity.startAnimating()
                            
                            // load the cards again
                            self.loadTheCardsAgain()
                        }
                         })
            })

        }
        
    }
    
    // load the cards again.  This could be our datatask
    func loadTheCardsAgain()
    {
        self.dataStrings = ["This has been fun to build\r~Alex Gibson","I have a couple of other animation that I came up with by working on this\r~Alex Gibson","If you find a way to improve this please let me know\r~Alex Gibson", "The fun of programming never stops.\r~Alex Gibson","This was fun to mess around with for a bit\r~Alex Gibson","I have figured out that things that took a long time to build before, only take a short time now\r~Alex Gibson","Have I mentioned that I like Objective C but I am learning Swift\r~Alex Gibson","Swift is great until you have to parse a JSON or do math\r~Alex Gibson","I like dot notation but I miss brackets and dot notation for setters and getters\r~Alex Gibson","Getting Tired of typing\r~Alex Gibson"]

        //delay here only to make it seem like it took time to load
        // simulating download time
        self.delay(0.8, closure: {

            // call animation to bring cards on to screen and stop activity view
           self.finalAnimationToReturn()

            })

    }
    
    func finalAnimationToReturn(){
        
        // hide all of the views from the user
        self.baseView.alpha = 0
        self.dummyView.alpha = 0
        self.bottomCardView.alpha = 0
        self.topCardView.alpha = 0
        
        
        // have to do this for the baseView because I don't reset this anywhere else in the code
        self.baseView.bounds = self.baseOriginalBounds
        self.baseView.center = self.baseOriginalCenter
        self.baseView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        // calling a reset on views to load datasource but still not visible
        // to the user
        self.resetViewsAndNewData()
   
        // the views are in the center now but not visible

        // stop activiy view
        self.activity.stopAnimating()
        
        //animate the cards back on screen
        UIView.animateWithDuration(0.5, animations: {
            
            // make all of the views visible
            self.baseView.alpha = 1
            self.dummyView.alpha = 1
            self.bottomCardView.alpha = 1
            self.topCardView.alpha = 1
            
            }, completion: {(finished:Bool)in
                
                // add the gesture back so the user can swipe cards away
                // it's go time
                self.topCardView.addGestureRecognizer(self.panGesture)
                
        })
    }

    
    
    
    
    // this is an awesome way to perform a delay when calling a function
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This is for our sliding cards but not for the stack of cards
    @IBOutlet weak var animateButton: UIButton!




}

