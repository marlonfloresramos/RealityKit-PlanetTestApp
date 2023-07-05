//
//  MainARViewController.swift
//  Planetary
//
//  Created by Marlon Gabriel Flores Ramos on 4/07/23.
//

import UIKit
import RealityKit
import ARKit

class MainARViewController: UIViewController {
    
    var completionHandler: ((Entity?) -> Void)?
    
    lazy var arView: ARView = {
        let view = ARView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(completionHandler: @escaping (Entity?) -> Void) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        setupARView()
    }
    
    func setupARView() {
        var spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinner)
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])

        EarthProject.loadEarthAsync { [weak self] result in
            spinner.removeFromSuperview()
            switch result {
            case .success(let earth):
                guard let self else { return }
                let session = self.arView.session
                let config = ARWorldTrackingConfiguration()
                config.planeDetection = [.horizontal]
                session.run(config)

                let coachingOverlay = ARCoachingOverlayView()
                coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
                coachingOverlay.session = session
                coachingOverlay.goal = .horizontalPlane
                self.arView.addSubview(coachingOverlay)
                
                NSLayoutConstraint.activate([
                    coachingOverlay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
                    coachingOverlay.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
                ])

                #if DEBUG
                self.arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
                #endif
                
                let anchor: EarthProject.Earth = earth
                anchor.generateCollisionShapes(recursive: true)
                self.arView.scene.anchors.append(anchor)
                anchor.actions.earthTapped.onAction = { entity in
                    self.completionHandler?(entity)
                }
                anchor.actions.moonTapped.onAction = { entity in
                    self.completionHandler?(entity)
                }
                anchor.actions.sunTapped.onAction = { entity in
                    self.completionHandler?(entity)
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }

}
