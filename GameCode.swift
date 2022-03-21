import Foundation
//Ball
let ball = OvalShape(width: 40, height: 40)

//Barrier
var barriers: [Shape] = []

//Funnel
let funnelPoints = [Point(x: 0, y: 50), Point(x: 80, y: 50), Point(x: 60, y: 0), Point(x: 20, y:0)]
let funnel = PolygonShape(points: funnelPoints)

//Target
var targets: [Shape] = []

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

fileprivate func setupBall() {
    ball.position = Point(x:250, y:400)
    ball.hasPhysics = true
    ball.fillColor = .green
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    ball.onTapped = resetGame
    ball.bounciness = 0.7
    
    scene.add(ball)
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    
    let barrierPoints = [ Point(x: 0, y: 0), Point(x: 0, y: height), Point(x: width, y: height), Point(x: width, y: 0)]
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
        
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.angle = angle
    barrier.isDraggable = true
    
    scene.add(barrier)
}

fileprivate func setupFunnel() {
    funnel.position = Point(x:200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.isDraggable = false
    
    scene.add(funnel)
}

fileprivate func addTarget(at position: Point) {
    let targetPoints = [Point(x: 10, y: 0), Point(x: 0, y: 10), Point(x: 10, y: 20), Point(x: 20, y:10)]
    let target = PolygonShape(points: targetPoints)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .red
    target.name = "target"
    target.isDraggable = false
    
    scene.add(target)
}

func setup() {
    
    setupBall()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 200, y: 70), width: 80, height: 25, angle: -0.1)
    
    setupFunnel()
    
    addTarget(at: Point(x:200, y: 686))
    addTarget(at: Point(x:339, y: 505))
    addTarget(at: Point(x:146, y: 59))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}

fileprivate func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers{
        barrier.isDraggable = false
    }
    
    for target in targets{
        target.fillColor = .red
    }
}

fileprivate func ballCollided(with otherShape: Shape){
    if otherShape.name != "target" {return}
    otherShape.fillColor = .blue
}

fileprivate func ballExitedScene(){
    for barrier in barriers{
        barrier.isDraggable = true
    }
    
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .blue {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
}

fileprivate func resetGame(){
    ball.position = Point(x: 0, y: -80)
}

fileprivate func printPosition(of shape: Shape) {
    print(shape.position)
}

fileprivate func alertDismissed(){}
