//
//  ContentView.swift
//  Planetary
//
//  Created by Marlon Gabriel Flores Ramos on 2/07/23.
//

import SwiftUI
import SceneKit

struct SpaceObject {
    let name: String
    let description: String
    let sceneName: String
}

struct DetailView: View {
    
    let spaceObject: SpaceObject
    var scene: SCNScene?
    @State private var orientation = UIDevice.current.orientation
    
    init(spaceObject: SpaceObject) {
        self.spaceObject = spaceObject
        scene = SCNScene(named: spaceObject.sceneName)
        scene?.background.contents = UIColor.black
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            Group {
                if orientation.isPortrait {
                    VStack {
                        Text(spaceObject.name)
                            .foregroundColor(.white)
                            .font(.title)
                        SceneView(scene: scene, options: [.allowsCameraControl, .autoenablesDefaultLighting])
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                        Text(spaceObject.description)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        Spacer()
                    }
                } else {
                    VStack {
                        Text(spaceObject.name)
                            .foregroundColor(.white)
                            .font(.title)
                        HStack {
                            SceneView(scene: scene, options: [.allowsCameraControl, .autoenablesDefaultLighting])
                                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height*0.8)
                            Text(spaceObject.description)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                rotateObject()
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    func rotateObject() {
        if let scene {
            let object = scene.rootNode.childNodes.first
            object!.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: .pi/12, z: 0, duration: 1)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(spaceObject: SpaceObject(name: "Earth", description: "Our home planet Earth is a rocky, terrestrial planet. It has a solid and active surface with mountains, valleys, canyons, plains and so much more. Earth is special because it is an ocean planet. Water covers 70% of Earth's surface.", sceneName: "Earth.usdz"))
    }
}
