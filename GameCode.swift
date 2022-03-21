import Foundation
//Ball
let ball = OvalShape(width: 40, height: 40)

//Barrier
let barrierWidth = 300.0
let barrierHeight = 25.0
let barrierPoints = [Point(x: 0, y: 0), Point(x: 0, y: barrierHeight), Point(x: barrierWidth, y: barrierHeight), Point(x: barrierWidth, y: 0)]
let barrier = PolygonShape(points: barrierPoints)

//Funnel
let funnelPoints = [Point(x: 0, y: 50), Point(x: 80, y: 50), Point(x: 60, y: 0), Point(x: 20, y:0)]
let funnel = PolygonShape(points: funnelPoints)

//Target
let targetPoints = [Point(x: 10, y: 0), Point(x: 0, y: 10), Point(x: 10, y: 20), Point(x: 20, y:10)]
let target = PolygonShape(points: targetPoints)

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

fileprivate func setupBarrier() {
    barrier.position = Point(x:200, y:150)
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.angle = 0.1
    
    scene.add(barrier)
}

fileprivate func setupFunnel() {
    funnel.position = Point(x:200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.isDraggable = false
    
    scene.add(funnel)
}

fileprivate func setupTarget() {
    target.position = Point(x:42, y:304)
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
    
    setupBarrier()
    
    setupFunnel()
    
    setupTarget()
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}

fileprivate func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    barrier.isDraggable = false
}

fileprivate func ballCollided(with otherShape: Shape){
    if otherShape.name != "target" {return}
    otherShape.fillColor = .blue
}

fileprivate func ballExitedScene(){
    barrier.isDraggable = true
}

fileprivate func resetGame(){
    ball.position = Point(x: 0, y: -80)
}

fileprivate func printPosition(of shape: Shape) {
    print(shape.position)
}
