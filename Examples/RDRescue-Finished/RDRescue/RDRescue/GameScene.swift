/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit
import BrainyRL

enum Actions: Int {
  case stand
  case up
  case down
  case left
  case right
}

class GameScene: SKScene {

  // BRAIN
  let brain: Brainy = Brainy()
  var lastPosition: CGPoint = CGPoint.zero
  
  let actions_space: [Int] = [Actions.stand.rawValue, Actions.up.rawValue, Actions.down.rawValue, Actions.left.rawValue, Actions.right.rawValue]

  lazy var rupeeSound:SKAction = {
    return SKAction.playSoundFileNamed("rupee.wav", waitForCompletion: false)
  }()
  lazy var hurtSound:SKAction = {
    return SKAction.playSoundFileNamed("hurt.wav", waitForCompletion: false)
  }()

  var landBackground:SKTileMapNode!
  var objectsTileMap:SKTileMapNode!
  var states_map: SKTileMapNode!

  // constants
  let waterMaxSpeed: CGFloat = 2000
  let landMaxSpeed: CGFloat = 4000

  // if within threshold range of the target, car begins slowing
  let targetThreshold:CGFloat = 200

  var maxSpeed: CGFloat = 0
  var acceleration: CGFloat = 0
  
  // touch location
  var targetLocation: CGPoint = .zero
  
  // Scene Nodes
  var agent: SKSpriteNode!

  override func didMove(to view: SKView) {
    loadSceneNodes()
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    maxSpeed = landMaxSpeed

    setupObjects()
//    let playButton = Button(defaultButtonImage: "Think", activeButtonImage: "START", buttonAction: loadGameScene)
//    playButton.position = CGPoint(x: 10, y: 10)
//    addChild(playButton)
  }
  
  func loadGameScene() {
    try! brain.think()
  }
  
  func loadSceneNodes() {
    guard let link = childNode(withName: "link") as? SKSpriteNode else {
      fatalError("Sprite Nodes not loaded")
    }
    self.agent = link
    
    guard let landBackground = childNode(withName: "landBackground")
      as? SKTileMapNode else {
        fatalError("Background node not loaded")
    }
    self.landBackground = landBackground
  }

  func setupObjects() {
    let columns = 32
    let rows = 24
    let size = CGSize(width: 64, height: 64)
    //self.QTable = Array(repeating: Array(repeating: 0, count: self.kColumns), count: self.kRows)

    // 1
    guard let tileSet = SKTileSet(named: "Object Tiles") else {
      fatalError("Object Tiles Tile Set not found")
    }
    
    // 2
    objectsTileMap = SKTileMapNode(tileSet: tileSet,
                                   columns: columns,
                                   rows: rows,
                                   tileSize: size)
    
    // 3
    addChild(objectsTileMap)
    
    // 4
    let tileGroups = tileSet.tileGroups
    
    // 5
    guard let duckTile = tileGroups.first(where: {$0.name == "Duck"}) else {
      fatalError("No Duck tile definition found")
    }
    guard let gascanTile = tileGroups.first(where: {$0.name == "Gas Can"}) else {
      fatalError("No Gas Can tile definition found")
    }
    guard let emptyTile = tileGroups.first(where: {$0.name == "emptyTile"}) else {
      fatalError("No Duck tile definition found")
    }
    
    // 6
    let numberOfObjects = 64
    
    // 7
    for _ in 1...numberOfObjects {
      
      // 8
      let column = Int(arc4random_uniform(UInt32(columns)))
      let row = Int(arc4random_uniform(UInt32(rows)))
      
      let groundTile = landBackground.tileDefinition(atColumn: column, row: row)
      
      // 9
      let tile = groundTile == nil ? duckTile : gascanTile
      
      // 10
      objectsTileMap.setTileGroup(tile, forColumn: column, row: row)
    }
    
    //Generate States
    states_map = SKTileMapNode(tileSet: tileSet,
                                   columns: columns,
                                   rows: rows,
                                   tileSize: size)
    addChild(states_map)
    var state_name: Int = 0
    for row in 0..<states_map.numberOfRows {
      for column in 0..<states_map.numberOfColumns {
        emptyTile.name = "\(state_name)"
        //states_map.tileDefinition(atColumn: column, row: row)
        states_map.setTileGroup(emptyTile, forColumn: column, row: row)
       // try! brain.updateQtable(row: row, column: column, value: state_name)
//        states_map.setTileGroup(emptyTile, forColumn: column, row: row)
        state_name = state_name + 1
      }
    }

     brainSetup()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    targetLocation = touch.location(in: self)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    targetLocation = touch.location(in: self)
  }
  
  override func update(_ currentTime: TimeInterval) {
    let position = agent.position
    let column = landBackground.tileColumnIndex(fromPosition: position)
    let row = landBackground.tileRowIndex(fromPosition: position)
    let tile = landBackground.tileDefinition(atColumn: column, row: row)

    if tile == nil {
      maxSpeed = waterMaxSpeed
      print("water")
    } else {
      maxSpeed = landMaxSpeed
      print("grass")
    }
    
    let objectTile = objectsTileMap.tileDefinition(atColumn: column, row: row)
    
    if let _ = objectTile?.userData?.value(forKey: "gascan") {
      run(rupeeSound)
      objectsTileMap.setTileGroup(nil, forColumn: column, row: row)
    }
    
    if let _ = objectTile?.userData?.value(forKey: "duck") {
      run(hurtSound)
      objectsTileMap.setTileGroup(nil, forColumn: column, row: row)
    }
    
     try! brain.think()
  }
  
  override func didSimulatePhysics() {
    
    let offset = CGPoint(x: targetLocation.x - agent.position.x,
                         y: targetLocation.y - agent.position.y)
    let distance = sqrt(offset.x * offset.x + offset.y * offset.y)
    let carDirection = CGPoint(x:offset.x / distance,
                               y:offset.y / distance)
    let carVelocity = CGPoint(x: carDirection.x * acceleration,
                              y: carDirection.y * acceleration)
    
    agent.physicsBody?.velocity = CGVector(dx: carVelocity.x, dy: carVelocity.y)
    
//    if acceleration > 5 {
//      agent.zRotation = atan2(carVelocity.y, carVelocity.x)
//    }
    
    // update acceleration
    // agent speeds up to maximum
    // if within threshold range of the target, car begins slowing
    // if maxSpeed has reduced due to different tiles,
    // may need to decelerate slowly to the new maxSpeed
    
    if distance < targetThreshold {
      let delta = targetThreshold - distance
      acceleration = acceleration * ((targetThreshold - delta)/targetThreshold)
      if acceleration < 2 {
        acceleration = 0
      }
    } else {
      if acceleration > maxSpeed {
        acceleration -= min(acceleration - maxSpeed, 100)
      }
      if acceleration < maxSpeed {
        acceleration += min(maxSpeed - acceleration, 60)
      }
    }

  }

  // MARK: BRAINY
  func brainSetup() {
    //update targetLocation
    let states: Int = objectsTileMap.numberOfRows * objectsTileMap.numberOfRows
    brain.setupEnvironment(numberOfStates: states,
                           action_space: actions_space,
                           terminalState: -1)
    try! brain.setupEnvironmentActions(whereToMove: whereToMove, getReward: getReward, isTerminalState: isTerminalState)
  }

  //this function gives you the "nextState"
  private func whereToMove(_ action: Int) -> Int {
    print("action \(action)")
    let position = agent.position
    var column = landBackground.tileColumnIndex(fromPosition: position)
    var row = landBackground.tileRowIndex(fromPosition: position)
 
    if action == Actions.up.rawValue {
      if row > 0 {
        row = row - 1
      } else {
        row = 0
      }
    }
    if action == Actions.down.rawValue {
      row = row + 1
    }
    if action == Actions.left.rawValue {
      if column > 0 {
        column = column - 1
      } else {
        column = 0
      }
    }
    if action == Actions.left.rawValue {
      column = column + 1
    }
    print("Moving to: \(action)")
    print("column: \(column)")
    print("row: \(row)")

    let destination = landBackground.centerOfTile(atColumn: column, row: row)
    let tile = states_map.tileGroup(atColumn: column, row: row)
    
    //let state_name = states_map.tileDefinition(atColumn: column, row: row)
    
    let state_name:Int = Int(tile?.name ?? "0") ?? 0
    print("\n state_name: \(state_name)")

    
    let action = SKAction.move(to: destination, duration: 0.1)
    print("\n Agent position: \(agent.position)")
    if lastPosition != agent.position {
     // agent.run(action)
    }
    lastPosition = agent.position
    agent.run(action)
    //targetLocation = lastPosition
    
    print("\n nextState: \(state_name)")
    return state_name
  }

  private func getReward(_ state: Int) -> Int {
    let position = agent.position
    let column = landBackground.tileColumnIndex(fromPosition: position)
    let row = landBackground.tileRowIndex(fromPosition: position)

    var reward: Int = 0
    let objectTile = objectsTileMap.tileDefinition(atColumn: column, row: row)
    if let _ = objectTile?.userData?.value(forKey: "duck") {
      reward = -1
    }
    if let _ = objectTile?.userData?.value(forKey: "gascan") {
       reward = 1
    }
    return reward
  }

//  func mapStatePosition(state: Int) -> CGPoint {
//
//  }
  
  
  private func isTerminalState(_ state: Int) -> Bool {
    return false
  }

}
