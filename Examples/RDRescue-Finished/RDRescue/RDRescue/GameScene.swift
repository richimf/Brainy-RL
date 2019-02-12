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

struct State {
  public let stateId: Int
  public let position: CGPoint
  init(stateId: Int, position: CGPoint) {
    self.stateId = stateId
    self.position = position
  }
}

class GameScene: SKScene {

  typealias NextState = Int
  // BRAIN
  let brain: Brainy = Brainy()
  var lastPosition: CGPoint = CGPoint.zero
  let terminal_state: Int = 600
  //let step: CGFloat = 100.0
  
  var x_window: CGFloat = 0.0
  var y_window: CGFloat = 0.0
  
  //State = 0 is position = 0
  var states: [CGPoint] = []
  //var states: [State] = []

  // Scene Nodes
  var agent: SKSpriteNode!
  
  let columns = 32
  let rows = 24
  
  // ACTIONS SPACE
  let actions_space: [Int] = [Actions.stand.rawValue,
                              Actions.up.rawValue,
                              Actions.down.rawValue,
                              Actions.left.rawValue,
                              Actions.right.rawValue]

  lazy var rupeeSound: SKAction = {
    return SKAction.playSoundFileNamed("rupee.wav", waitForCompletion: false)
  }()
  lazy var hurtSound: SKAction = {
    return SKAction.playSoundFileNamed("hurt.wav", waitForCompletion: false)
  }()

  var landBackground: SKTileMapNode!
  var objectsTileMap: SKTileMapNode!
  var states_map: SKTileMapNode!

  // constants
  let waterMaxSpeed: CGFloat = 3000
  let landMaxSpeed: CGFloat = 4000

  // if within threshold range of the target, car begins slowing
  let targetThreshold:CGFloat = 2000

  var maxSpeed: CGFloat = 0
  var acceleration: CGFloat = 0
  
  // touch location
  var targetLocation: CGPoint = .zero

  override func didMove(to view: SKView) {
    loadSceneNodes()
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    maxSpeed = landMaxSpeed
    setupObjects()
//    let playButton = Button(defaultButtonImage: "Think", activeButtonImage: "START", buttonAction: loadGameScene)
//    playButton.position = CGPoint(x: 10, y: 10)
//    addChild(playButton)
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
    let size = CGSize(width: 44, height: 44)
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
//    guard let emptyTile = tileGroups.first(where: {$0.name == "emptyTile"}) else {
//      fatalError("No Duck tile definition found")
//    }
    
    // 6, NUMBER OF RUPEES AND DOCKS
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
    
//    //Generate States
//    states_map = SKTileMapNode(tileSet: tileSet,
//                                   columns: columns,
//                                   rows: rows,
//                                   tileSize: size)
//    addChild(states_map)
//    var state_name: Int = 0
//    for row in 0..<states_map.numberOfRows {
//      for column in 0..<states_map.numberOfColumns {
//        emptyTile.name = "\(state_name)"
//        //states_map.tileDefinition(atColumn: column, row: row)
//        states_map.setTileGroup(emptyTile, forColumn: column, row: row)
//       // try! brain.updateQtable(row: row, column: column, value: state_name)
////        states_map.setTileGroup(emptyTile, forColumn: column, row: row)
//        state_name = state_name + 1
//      }
//    }

     brainSetup()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    //targetLocation = touch.location(in: self)
    targetLocation = CGPoint.zero
    agent.position = CGPoint.zero
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    //targetLocation = touch.location(in: self)
    targetLocation = CGPoint.zero
    agent.position = CGPoint.zero
  }
  
  override func update(_ currentTime: TimeInterval) {
    let position = agent.position
    let column = landBackground.tileColumnIndex(fromPosition: position)
    let row = landBackground.tileRowIndex(fromPosition: position)
    let tile = landBackground.tileDefinition(atColumn: column, row: row)

    if tile == nil {
      maxSpeed = waterMaxSpeed
      //print("water")
    } else {
      maxSpeed = landMaxSpeed
      //print("grass")
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
    let numberOfRows = objectsTileMap.numberOfRows
    let numberOfColumns = objectsTileMap.numberOfColumns
    let states_number: Int = numberOfRows * numberOfColumns
    
    createStatesMap(rows: numberOfRows, columns: numberOfColumns)
    
    brain.setupEnvironment(numberOfStates: states_number,
                           action_space: actions_space,
                           terminalState: terminal_state)
    try! brain.setupEnvironmentActions(whereToMove: whereToMove, getReward: getReward, isTerminalState: isTerminalState)
  }
  
  private func createStatesMap(rows: Int, columns: Int) {
    let height = objectsTileMap.mapSize.height
    let width = objectsTileMap.mapSize.width
    //this is the size of square
    x_window = height/CGFloat(rows)
    y_window = width/CGFloat(columns)
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var stateId: Int = 0

    repeat {
      x = x + x_window
      if x >= height {
        y = y + y_window
        x = 0
      }
      stateId = stateId + 1
      let point = CGPoint(x: x, y: y)
      //let s: State = State(stateId: stateId, position: point)
      states.append(point)
    } while(y < width)
    
  }

  //this function gives you the "nextState" next_state
  private func whereToMove(_ action: Int) -> NextState {
    let position: CGPoint = agent.position
    var newPosition: CGPoint = .zero
    //var column = landBackground.tileColumnIndex(fromPosition: position)
    //var row = landBackground.tileRowIndex(fromPosition: position)
    //action
    
    if action == Actions.up.rawValue {
      print("up")
      newPosition = CGPoint(x: position.x, y: position.y + y_window)
    }else if action == Actions.down.rawValue {
       print("down")
      newPosition = CGPoint(x: position.x, y: position.y - y_window)
    } else if action == Actions.left.rawValue {
       print("left")
      newPosition = CGPoint(x: position.x - x_window, y: position.y)
    } else if action == Actions.right.rawValue {
       print("right")
      newPosition = CGPoint(x: position.x + x_window, y: position.y)
    } else {
      newPosition = position
    }
    let action = SKAction.move(to: newPosition, duration: 0.1)
    agent.run(action)
    targetLocation = newPosition
    
    let filtered_states = states.indices.filter {states[$0] == newPosition}
    if filtered_states.count > 0 {
      print("Next state \(filtered_states[0])")
      return filtered_states[0] //next state
    }
//    print("Agent position \(position)")
//    print("Next state \(next_state)")
    return 0
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
    print("Reward \(reward)")
    return reward
  }

  private func isTerminalState(_ state: Int) -> Bool {
    return state == terminal_state
  }

}
