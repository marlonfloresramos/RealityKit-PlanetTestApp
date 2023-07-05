//
//  MainARView.swift
//  Planetary
//
//  Created by Marlon Gabriel Flores Ramos on 2/07/23.
//

import SwiftUI
import RealityKit

struct MainARView: View {
    
    @State private var isPresentingDetailView = false
    @State private var selectedEntity: Entity? = nil
    
    var body: some View {
        NavigationStack {
            ARViewContainer { entity in
                isPresentingDetailView = true
                selectedEntity = entity
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $isPresentingDetailView) {
                if let selectedEntity {
                    DetailView(spaceObject: getSpaceObject(entity: selectedEntity))
                }
            }
        }
    }
    
    func getSpaceObject(entity: Entity) -> SpaceObject {
        switch entity.name {
        case "earth":
            return SpaceObject(name: "Earth", description: "Our home planet Earth is a rocky, terrestrial planet. It has a solid and active surface with mountains, valleys, canyons, plains and so much more. Earth is special because it is an ocean planet. Water covers 70% of Earth's surface.", sceneName: "Earth.usdz")
        case "moon":
            return SpaceObject(name: "Moon", description: "Our Moon is like a desert with plains, mountains, and valleys. It also has many craters, holes created when space rocks hit the surface at a high speed. There is no air to breathe on the Moon. The Moon travels around the Earth in an oval-shaped orbit.", sceneName: "Moon.usdz")
        case "sun":
            return SpaceObject(name: "Sun", description: "The Sun is a 4.5 billion-year-old yellow dwarf star – a hot glowing ball of hydrogen and helium – at the center of our solar system. It's about 93 million miles (150 million kilometers) from Earth and it's our solar system's only star. Without the Sun's energy, life as we know it could not exist on our home planet.", sceneName: "Sun.usdz")
        default:
            return SpaceObject(name: "Earth", description: "Our home planet Earth is a rocky, terrestrial planet. It has a solid and active surface with mountains, valleys, canyons, plains and so much more. Earth is special because it is an ocean planet. Water covers 70% of Earth's surface.", sceneName: "Earth.usdz")
        }
    }
}

struct ARViewContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainARViewController
    
    let completionHandler: ((Entity?) -> Void)
    
    func makeUIViewController(context: Context) -> MainARViewController {
        return MainARViewController(completionHandler: completionHandler)
    }
    
    func updateUIViewController(_ uiViewController: MainARViewController, context: Context) {
    }
}

struct MainARView_Previews: PreviewProvider {
    static var previews: some View {
        MainARView()
    }
}
