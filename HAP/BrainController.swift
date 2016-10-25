//
//  BrainController.swift
//  HAP
//
//  Created by Fredrik Loberg on 10/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import SceneKit

class BrainController: UIViewController {
    static let storyboardId = "brainViewController"

    @IBOutlet weak var brainSceneView: SCNView!
    @IBOutlet weak var infoHeader: UILabel!
    
    @IBOutlet weak var infoTextView: UITextView!
    var rewardPathNode: SCNNode!
    var prefrontalCortexNode: SCNNode!
    var prefrontalCortex2Node: SCNNode!
    var hippocampusNode: SCNNode!
    var hippocampus2Node: SCNNode!
    var brainStemNode: SCNNode!
    var littleBrainNode: SCNNode!
    var amygdalaNode: SCNNode!
    var brainBacksideNode: SCNNode!
    
    var lastTappedNode: SCNNode?
    
    var cameraNode: SCNNode!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brainSceneView.scene = makeBrainScene()
        brainSceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    fileprivate func makeBrainScene() ->SCNScene {
        let brainScene = SCNScene()
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0.33, y: 0.3, z: 5)
        brainScene.rootNode.addChildNode(cameraNode)
        
        let rewardPathScene = SCNScene(named: "brain.scnassets/rewardpath")
        let prefrontalCortexScene = SCNScene(named: "brain.scnassets/prefrontalcortex.dae")
        let prefrontalCortex2Scene = SCNScene(named: "brain.scnassets/prefrontalcortex2.dae")
        let hippocampusScene = SCNScene(named: "brain.scnassets/hippocampus.dae")
        let hippocampus2Scene = SCNScene(named: "brain.scnassets/hippocampus2.dae")
        let brainStemScene = SCNScene(named: "brain.scnassets/brainstem.dae")
        let littleBrainScene = SCNScene(named: "brain.scnassets/littlebrain.dae")
        let amygdalaScene = SCNScene(named: "brain.scnassets/amygdala.dae")
        let brainBacksideScene = SCNScene(named: "brain.scnassets/brainbackside.dae")
        
        rewardPathNode = rewardPathScene!.rootNode.childNode(withName: "RewardPath", recursively: true)!
        prefrontalCortexNode = prefrontalCortexScene!.rootNode.childNode(withName: "PrefrontalCortex", recursively: true)!
        prefrontalCortex2Node = prefrontalCortex2Scene!.rootNode.childNode(withName: "PrefrontalCortex2", recursively: true)!
        hippocampusNode = hippocampusScene!.rootNode.childNode(withName: "Hippocampus", recursively: true)!
        hippocampus2Node = hippocampus2Scene!.rootNode.childNode(withName: "Hippocampus2", recursively: true)!
        brainStemNode = brainStemScene!.rootNode.childNode(withName: "BrainStem", recursively: true)!
        littleBrainNode = littleBrainScene!.rootNode.childNode(withName: "LittleBrain", recursively: true)!
        amygdalaNode = amygdalaScene!.rootNode.childNode(withName: "Amygdala", recursively: true)!
        brainBacksideNode = brainBacksideScene!.rootNode.childNode(withName: "BrainBackside", recursively: true)!
        
        
        let frontMaterial = UIImage(named: "frontBrain")
        let backMaterial = UIImage(named: "backBrain")
        let hippocampusThc = UIImage(named: "hippocampusTHC")
        
        rewardPathNode?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        prefrontalCortexNode?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        prefrontalCortex2Node?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        hippocampusNode?.geometry?.firstMaterial?.diffuse.contents = hippocampusThc
        hippocampus2Node?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        brainStemNode?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        littleBrainNode?.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        amygdalaNode.geometry?.firstMaterial?.diffuse.contents = frontMaterial
        brainBacksideNode?.geometry?.firstMaterial?.diffuse.contents = backMaterial
        
        brainScene.rootNode.addChildNode(rewardPathNode)
        brainScene.rootNode.addChildNode(prefrontalCortexNode)
        brainScene.rootNode.addChildNode(prefrontalCortex2Node)
        brainScene.rootNode.addChildNode(hippocampusNode)
        brainScene.rootNode.addChildNode(hippocampus2Node)
        brainScene.rootNode.addChildNode(brainStemNode)
        brainScene.rootNode.addChildNode(littleBrainNode)
        brainScene.rootNode.addChildNode(amygdalaNode)
        brainScene.rootNode.addChildNode(brainBacksideNode)
        
        return brainScene
    }
    
    func onTap(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: brainSceneView)
        let hits = brainSceneView.hitTest(location, options: nil)
        
        if let tappedNode = hits.first?.node {
            switch tappedNode {
            case brainBacksideNode, hippocampus2Node, prefrontalCortex2Node, brainStemNode:
                makeAllNodesVisible()
            default:
                if tappedNode == lastTappedNode { makeAllNodesVisible() }
                else { makeAllNodesTranslucentButSelected(tappedNode) }
            }
            
            switch tappedNode {
            case rewardPathNode:
                infoHeader.text = "Belønningsbanen"
                infoTextView.text = "Belønningsbanen er delen i hjernen som skiller ut dopamin. Dopamin er et hormon som gir de positive følelsene i kroppen som lykke, velvære og glede. Dette området kan spille en viktig rolle i å utvikle en avhengighet.  Området er en del av den eldre hjernedelen i forhold til overlevelse og har funksjon når man spiser, drikker eller har sex, eller det å ta vare på seg selv som individ (overlevelse). Da vil dette området påvirkes ved å skille ut dopamin, for at man skal ønske å gjøre atferden igjen. Det å spise, drikke og knytte oss til andre blir positivt forsterket.  Rus vil virke sterkere enn de naturlige stimuli og utkonkurrere de."
            case prefrontalCortexNode:
                infoHeader.text = "Fremre hjernebark"
                infoTextView.text = "Denne delen av hjernen styrer evnen til å ta valg, skifte perspektiv og tenke konsekvenser. Disse evnene trengs for blant annet å kunne organisere, planlegge og reflektere. Ved å røyke cannabis over tid nedreguleres reseptorene og blodtilstrømmingen blir mindre i dette området. Dette fører til at den kognitive fleksibiliteten blir redusert og en kan oppleve at ens evne til å forstå og erkjenne ikke er helt som før."
            case hippocampusNode:
                infoHeader.text = "Hippocampus"
                infoTextView.text = "Hippocampus er hukommelsessentralen, eller bibliotekaren i hjernen og knytepunktet for alle typer læring. Reseptorene nedreguleres i dette området dersom man røyker cannabis over tid, og både det å hente ut og legge inn informasjon blir svekket. Kortidshukommelsen kan svekkes ved røyking av cannabis over tid."
            case littleBrainNode:
                infoHeader.text = "Lillehjernen"
                infoTextView.text = "Denne delen er ansvarlig for å koordinere forskjellige muskelbevegelser som f.eks å styre finmotorikken eller kontrollere balanseevenen. Ved regelmessig inntak av cannabis vil en oppleve at balansen er ustø, og det å utføre oppgaver som f.eks findetaljert arbeid er vanskeligere. For trafikanter er risikoen for trafikkulykker 9-10 ganger høyere hos de som røyker minst én gang i uken, både fordi man opplever usikker styring og reaksjonstiden blir enda tregere enn normalt."
            case amygdalaNode:
                infoHeader.text = "Amygdala"
                infoTextView.text = "Amygdala er en del av hjernens limbiske system som involverer motivasjon og emosjoner, som blant annet frykt, sinne, nytelse og lignende. Ved å røyke cannabis over tid vil amygdalas virkeområde “skrus opp” og forsterke følelsene. Dette kan både være positive følelser som lykke, og negative følelser som paranoia og angst."
            default: infoHeader.text = "Trykk på en hjernedel"
                infoTextView.text = "Trykk på en hjernedel for å se litt informasjon om den, og hvordan THC påvirker din hjerne."
            }
        }
    }
    
    fileprivate func makeAllNodesVisible(){
        lastTappedNode = nil
        for node in brainSceneView.scene!.rootNode.childNodes {
            node.opacity = 1
        }
    }
    
    fileprivate func makeAllNodesTranslucentButSelected(_ tappedNode:SCNNode){
        lastTappedNode = tappedNode
        for node in brainSceneView.scene!.rootNode.childNodes {
            if node == tappedNode { node.opacity = 1 }
            else { node.opacity = 0.3 }
        }
    }
}
