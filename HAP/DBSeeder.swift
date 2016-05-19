//
//  DBSeeder.swift
//  HAP
//
//  Created by Fredrik Loberg on 06/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class DBSeeder {
    
    class func SeedDB(){
        makeInfo()
        feedAchievements()
        createTriggers()
    }
    
    class func makeInfo(){
        let helpInfoDao = HelpInfoDao()
        helpInfoDao.deleteAll()
        
        let sec1 = helpInfoDao.createNewHelpInfoCategory(1, title: "Råd og Tips")
        let sec2 = helpInfoDao.createNewHelpInfoCategory(2, title: "Abstinenser")
        let sec3 = helpInfoDao.createNewHelpInfoCategory(3, title: "Følelser")
        let sec4 = helpInfoDao.createNewHelpInfoCategory(4, title: "Cannabisinformasjon")
        let sec5 = helpInfoDao.createNewHelpInfoCategory(5, title: "Hjernen")
        let sec6 = helpInfoDao.createNewHelpInfoCategory(6, title: "Sosialt Fokus")
        let sec7 = helpInfoDao.createNewHelpInfoCategory(7, title: "Tilbakefall")
        let sec8 = helpInfoDao.createNewHelpInfoCategory(8, title: "Øvelser")
        let sec9 = helpInfoDao.createNewHelpInfoCategory(9, title: "Program")
        
        
        let i1 = helpInfoDao.createNewHelpInfo("Praktiske råd når du skal slutte", htmlContent: "praktiskerad")
        let i2 = helpInfoDao.createNewHelpInfo("Tips til andre aktiviteter", htmlContent: "tipstilandreaktiviteter")
        let i3 = helpInfoDao.createNewHelpInfo("Motivasjon", htmlContent: "motivasjon")
        let i5 = helpInfoDao.createNewHelpInfo("Hjelpetilbud og behandligstilbud", htmlContent: "hjelpetilbudogbehandlingstilbud")
        let i7 = helpInfoDao.createNewHelpInfo("Strategier", htmlContent: "strategier")
        let i8 = helpInfoDao.createNewHelpInfo("Risikosituasjoner og triggere", htmlContent: "risikosituasjonerogtriggere")
        sec1.helpInfo = [i1, i2, i3, i5, i7, i8]
        
        let i9 = helpInfoDao.createNewHelpInfo("Aggresjon og sinne", htmlContent: "aggresjonogsinne")
        let i10 = helpInfoDao.createNewHelpInfo("Søvnproblemer, Mareritt og intense drømmer.", htmlContent: "sovnproblemer")
        let i11 = helpInfoDao.createNewHelpInfo("Nedsatt appetitt", htmlContent: "nedsattappetitt")
        let i12 = helpInfoDao.createNewHelpInfo("Svetting, Skjelving eller Vondt i hodet.", htmlContent: "svetting")
        let i13 = helpInfoDao.createNewHelpInfo("Magetrøbbel", htmlContent: "magetrobbel")
        let i15 = helpInfoDao.createNewHelpInfo("Nedtrykhet", htmlContent: "nedtrykhet")
        let i16 = helpInfoDao.createNewHelpInfo("Suget", htmlContent: "suget")
        
        sec2.helpInfo = [i9, i10, i11, i12, i13, i15, i16]
        
        let i17 = helpInfoDao.createNewHelpInfo("Angst, Uro og Rastløshet", htmlContent: "angsturoograstloshet")
        let i18 = helpInfoDao.createNewHelpInfo("Ensomhet, Forlatthet, Isolasjon", htmlContent: "ensomhetforlatthetisolasjon")
        let i20 = helpInfoDao.createNewHelpInfo("Lykke, oppstemthet, belønning,  velbehag", htmlContent: "lykkeoppstemhetbelonningvelbehag")
        
        sec3.helpInfo = [i17, i18, i20]
        
        let i23 = helpInfoDao.createNewHelpInfo("Cannabis", htmlContent: "cannabis")
        let i27 = helpInfoDao.createNewHelpInfo("Mulige skadevirkninger ved bruk av cannabis", htmlContent: "muligeskadevirkninger")
        let i28 = helpInfoDao.createNewHelpInfo("Positive effekter av å redusere/slutte med cannabis bruk", htmlContent: "positiveeffekteravareduse")
        
        sec4.helpInfo = [i23, i27, i28]
        
        let i30 = helpInfoDao.createNewHelpInfo("Kognisjon", htmlContent: "kognisjon")
        let i31 = helpInfoDao.createNewHelpInfo("3D-Hjernen", htmlContent: " ")
        
        sec5.helpInfo = [i30, i31]
        
        let i32 = helpInfoDao.createNewHelpInfo("Nettverk", htmlContent: "nettverk")
        let i33 = helpInfoDao.createNewHelpInfo("Identitet “Før og nå”", htmlContent: "identitet")
        let i34 = helpInfoDao.createNewHelpInfo("Fremtiden", htmlContent: "fremtiden")
        
        sec6.helpInfo = [i32, i33, i34]
        
        let i35 = helpInfoDao.createNewHelpInfo("Vanlige årsaker til tilbakefall", htmlContent: "vanligearsaker")
        let i36 = helpInfoDao.createNewHelpInfo("Forebygging av tilbakefall", htmlContent: "forebygging")
    
        sec7.helpInfo = [i35, i36]
        
        let i37 = helpInfoDao.createNewHelpInfo("ABCD-modell", htmlContent: "abcdmodel")
        let i38 = helpInfoDao.createNewHelpInfo("Avslapningsøvelse", htmlContent: "avslappningsovelser")
        let i39 = helpInfoDao.createNewHelpInfo("FAK-modellen", htmlContent: "fakmodellen")
        let i40 = helpInfoDao.createNewHelpInfo("Nettverksplanlegging", htmlContent: "nettverksplanlegging")
        let i41 = helpInfoDao.createNewHelpInfo("Tribuneperspektiv", htmlContent: "tribuneperspektiv")
        
        sec8.helpInfo = [i37, i38, i39, i40, i41]
        
        let i42 = helpInfoDao.createNewHelpInfo("Fase 1 - Fysisk fokus, dag 1-11", htmlContent: "fase1")
        let i43 = helpInfoDao.createNewHelpInfo("Fase 2 - Psykologisk fokus, dag 12-21", htmlContent: "fase2")
        let i44 = helpInfoDao.createNewHelpInfo("Fase 3 - Sosialt fokus, dag 21-56 ", htmlContent: "fase3")
        let i45 = helpInfoDao.createNewHelpInfo("Hasjavvenningsprogrammet", htmlContent: "hasjavvenningsprogrammet")
        
        sec9.helpInfo = [i42, i43, i44, i45]
        
        helpInfoDao.save()
    }
    
    class func feedAchievements(){
        let achievementDao = AchievementDao()
        achievementDao.deleteAll()
        
        //minorMilestone
        achievementDao.createNewAchievement("Første dagen uten!", info: "Du har klart din første dag uten cannabis!", pointsRequired: 86400, category: .MinorMilestone)
        achievementDao.createNewAchievement("3 dager uten!", info: "Du har klart 3 dager uten cannabis!", pointsRequired: 259200, category: .MinorMilestone)
        achievementDao.createNewAchievement("2 uker uten!", info: "Du har klart to uker uten cannabis!", pointsRequired: 1209600, category: .MinorMilestone)
        achievementDao.createNewAchievement("3 uker uten!", info: "Du har tre uker uten cannabis!", pointsRequired: 1814400, category: .MinorMilestone)
        achievementDao.createNewAchievement("En måned uten!", info: "Du har klart deg en hel måned uten cannabis!", pointsRequired: 2628003, category: .MinorMilestone)
        achievementDao.createNewAchievement("5 uker uten!", info: "Du har holdt deg fem uker uten cannabis!", pointsRequired: 3024000, category: .MinorMilestone)
        achievementDao.createNewAchievement("6 uker uten!", info: "Du har holdt deg seks uker uten cannabis!", pointsRequired: 3628800, category: .MinorMilestone)
        achievementDao.createNewAchievement("7 uker uten!", info: "Du har holdt deg syv uker uten cannabis!", pointsRequired: 4233600, category: .MinorMilestone)
        achievementDao.createNewAchievement("2 måneder uten!", info: "Du har holdt deg to måneder uten cannabis!", pointsRequired: 5184000, category: .MinorMilestone)
        
        //Milestone
        achievementDao.createNewAchievement("Første skrittet!", info: "Du har tatt det første skrittet mot en rusfri hverdag!", pointsRequired: 1, category: .Milestone)
        achievementDao.createNewAchievement("Første uken uten!", info: "Du har klart en uke uten cannabis!", pointsRequired: 604800, category: .Milestone)
        achievementDao.createNewAchievement("Fase 1 gjennomført!", info: "Du har kommet deg gjennom fase 1 av HAP programmet!", pointsRequired: 1036800, category: .Milestone)
        achievementDao.createNewAchievement("Fase 2 gjennomført!", info: "Du har kommet deg gjennom fase 2 av HAP programmet!", pointsRequired: 1814400, category: .Milestone)
        achievementDao.createNewAchievement("HAP gjennomført!", info: "Du har kommet deg gjennom HAP programmet, det er 8 uker rusfri!", pointsRequired: 4838400, category: .Milestone)
        achievementDao.createNewAchievement("Et halvt år uten!", info: "Du har holdt deg et halvt år uten cannabis!", pointsRequired: 15768000, category: .Milestone)
        achievementDao.createNewAchievement("Et helt år uten!", info: "Du har holdt deg et helt år uten cannabis!", pointsRequired: 31536000, category: .Milestone)
        achievementDao.createNewAchievement("To år uten!", info: "Du har holdt deg to år uten cannabis!", pointsRequired: 63072000, category: .Milestone)
        achievementDao.createNewAchievement("Tre år uten!", info: "Du har holdt deg tre år uten cannabis!", pointsRequired: 94608000, category: .Milestone)
        achievementDao.createNewAchievement("Fire år uten!", info: "Du har holdt deg fire år uten cannabis!", pointsRequired: 126144000, category: .Milestone)
        achievementDao.createNewAchievement("Fem år uten!", info: "Du har holdt deg fem år uten cannabis!", pointsRequired: 157680000, category: .Milestone)
        
        //Economic
        achievementDao.createNewAchievement("Brukt kalkulatoren!", info: "Du har tatt i bruk kalkulatoren!", pointsRequired: 1, category: .Economic)
        achievementDao.createNewAchievement("1000 kr Spart!", info: "Du har spart 1000 kr!", pointsRequired: 1000, category: .Economic)
        achievementDao.createNewAchievement("5000 kr Spart!", info: "Du har spart 5000 kr!", pointsRequired: 5000, category: .Economic)
        achievementDao.createNewAchievement("10 000 kr Spart!", info: "Du har spart 10 000 kr!", pointsRequired: 10000, category: .Economic)
        achievementDao.createNewAchievement("20 000 kr Spart!", info: "Du har spart 20 000 kr!", pointsRequired: 20000, category: .Economic)
        achievementDao.createNewAchievement("30 000 kr Spart!", info: "Du har spart 30 000 kr!", pointsRequired: 30000, category: .Economic)
        achievementDao.createNewAchievement("40 000 kr Spart!", info: "Du har spart 40 000 kr!", pointsRequired: 40000, category: .Economic)
        achievementDao.createNewAchievement("50 000 kr Spart!", info: "Du har spart 50 000 kr!", pointsRequired: 50000, category: .Economic)
        achievementDao.createNewAchievement("100 000!", info: "Du har spart hele 100 000 kr!", pointsRequired: 100000, category: .Economic)
        achievementDao.createNewAchievement("1 000 000!", info: "Du har spart hele 1 000 000 kr!", pointsRequired: 1000000, category: .Economic)
        
        //Health
        achievementDao.createNewAchievement("Mer matlyst", info: "Nå opplever mange å få bedre matlyst/appetitt", pointsRequired: 777600, category: .Health)
        achievementDao.createNewAchievement("Svetting", info: "Nå kan du forvente at svettingen begynner å avta", pointsRequired: 864000, category: .Health)
        achievementDao.createNewAchievement("Mindre rastløshet", info: "Her kan du forvente at rastløsheten vil roe seg", pointsRequired: 1296000, category: .Health)
        achievementDao.createNewAchievement("Om følelser", info: "Nå opplever flere at følelser som sinne, aggresjon og angst vil roe seg", pointsRequired: 1814400, category: .Health)
        achievementDao.createNewAchievement("Mindre irritasjon", info: "Nå opplever mange at de blir mindre irritable", pointsRequired: 1900800, category: .Health)
        achievementDao.createNewAchievement("Bedre korttidshukommelse", info: "Ofte vil korttidshukommelsen nå bli bedre", pointsRequired: 2592000, category: .Health)
        achievementDao.createNewAchievement("Bedre Søvn", info: "Nå opplever mange at de sover bedre, men søvnforstyrrelser kan vare lenger for noen", pointsRequired: 3456000, category: .Health)
        achievementDao.createNewAchievement("Sov Godt", info: "Nå kan du forvente at drømmeaktiviteten din blir mer rolig og stabil, og drømmene mindre intense", pointsRequired: 4320000, category: .Health)
        
        achievementDao.save()
    }
    
    class func createTriggers() {
        let triggerDAO = TriggerDao()
        triggerDAO.deleteAll()
        
        for triggerStruct in ResourceList.triggers {
            triggerDAO.createNewTrigger(triggerStruct.title, imageName: triggerStruct.imageName, color: triggerStruct.color)
        }
         triggerDAO.save()
    }
}
