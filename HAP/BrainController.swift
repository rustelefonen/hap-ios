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
                infoTextView.text = "Ved bruk av cannabis, vil THC aktivere belønningsbanen ved at det skilles ut dopamin. Stoffet dopamin er en signalsubstans (nevrotransmitter), det vil si et stoff som overfører kjemiske signaler fra en nervecelle til en annen, og det dannes naturlig i hjernen. Stoffet er viktig for hjernens belønnings- og motivasjonssystem, og kan spille en rolle i forhold til avhengighet. Denne påvirkningen vil for de aller fleste ledsages av en følelse av velvære, belønning og glede. Dette og nærliggende hjerneområder har som normalfunksjon å regulere atferd knyttet til motivasjon, lyst og glede ved viktige aktiviteter. Det kan være det å ta vare på seg selv som individ, drikke når man er tørst og spise når man er sulten. En annen funksjon er også videreføring av arten, ved at disse hjerneområdene blir aktivisert i forbindelse med lyst og glede knyttet til seksuell aktivitet og til pleie og omsorg for avkommet. Rusmidler «kaprer» dette området i hjernen og stimulerer det kraftigere enn naturlige stimuli. Hjernen kan lures til å tro at rusmidlene man bruker er livsviktige, og betydningen av rusmiddelet blir større over tid om man bruker det jevnlig. Ved langvarig cannabisbruk vil hjernens evne til å produsere og skille ut dopamin bli nedregulert. Derfor er det vanlig å oppleve nedstemthet og savn i en periode etter at man har sluttet. Vanligvis går dette over etter noen måneder når dopaminlagrene har oppjustert seg igjen. Du kan aktivt gjøre ting som vil påvirke dette området positivt etter å ha sluttet med cannabis. Det kan være å trene, spise god mat, ha fokus på velværeaktiviteter som massasje, ta et varmt bad, avslapningsøvelser, være ute i naturen, le, nyte en solnedgang etc."
            case prefrontalCortexNode:
                infoHeader.text = "Fremre hjernebark"
                infoTextView.text = "Dette området er et av de mest avanserte områdene i hjernen. Her har vi eksekutive funksjoner, som blant annet omfatter evne til å skifte perspektiv, til planlegging og til organisering. Evnen til å ta valg og reflektere, impulshåndtering og til å tenke konsekvenser lokaliseres også i dette området. Dersom man bruker cannabis over tid, vil dette området få mindre aktivitet ved at reseptorene nedreguleres. Ved målemetoder som måler blodtilstrømning i hjernen og billeddiagnostikk har man observert endret aktivitet og blodstrømning i hjernedeler med cannabisreseptorer. Cannabisbruk kan redusere den kognitive fleksibiliteten som er viktig for endringsprosesser. Den fremre hjernebarken er ikke ferdig utviklet i tenårene. Regelmessig cannabisrøyking i tenårene kan påvirke tenåringshjernens modningsprosesser."
            case hippocampusNode:
                infoHeader.text = "Hippocampus"
                infoTextView.text = "Hippocampus er hukommelsessentralen eller “bibliotekaren” i hjernen, og knutepunktet for alle typer læring. Reseptorene nedreguleres i dette området dersom man røyker cannabis over tid. Kortidshukommelsen kan svekkes ved røyking av cannabis, både under selve rusen, og om man røyker jevnlig over tid. Forskning viser at reseptorene i dette og andre områder i hjernen fortsetter å nedreguleres etter at man slutter, men reguleres opp igjen i løpet av en måneds avholdenhet. Kliniske erfaringer tyder på at mange får bedre korttidshukommelse igjen etter å ha sluttet med cannabis i tre til fem uker."
            case littleBrainNode:
                infoHeader.text = "Lillehjernen"
                infoTextView.text = "Lillehjernen er ansvarlig for å koordinere forskjellige muskelbevegelser som for eksempel å styre finmotorikken og kontrollere balanseevnen. Under cannabisrus vil du kunne oppleve at balansen er ustø, og det å utføre oppgaver som findetaljert arbeid er vanskeligere.  THC medfører reduserte kjøreferdigheter og gir økt risiko for trafikkulykker. Risikoen for å forårsake trafikkulykker øker med økende konsentrasjoner av THC."
            case amygdalaNode:
                infoHeader.text = "Amygdala"
                infoTextView.text = "Amygdala er en liten struktur lokalisert dypt inne i temporallappen i hjernen. Den er en limbisk systemstruktur som er involvert i mange av våre emosjoner og motivasjon, spesielt relatert til overlevelse. Amygdala er involvert i emosjoner som frykt, sinne og nytelse. Når man røyker cannabis, skrus «volumknappen» i amygdala opp og forsterker følelsene. Dette kan være både følelser som glede, interesse og overraskelse, samt følelser som paranoia, bekymring og angst."
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
