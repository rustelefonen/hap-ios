//
//  ResourceLists.swift
//  HAP
//
//  Created by Simen Fonnes on 23.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

struct ResourceList {
    static let gramType = ["Per dag", "Per uke", "Per måned"]
    static let genders = ["Mann", "Kvinne", "Annet"]
    static let genderValues = ["MALE", "FEMALE", "OTHER"]
    static let counties = ["Akershus", "Aust-Agder", "Buskerud", "Finnmark", "Hedmark", "Hordaland", "Møre og Romsdal", "Nord-Trøndelag", "Nordland", "Oppland", "Oslo", "Rogaland", "Sogn og Fjordane", "Sør-Trøndelag", "Telemark", "Troms", "Vest-Agder", "Vestfold", "Østfold"]
    static let userTypes = ["Jeg bruker cannabis", "Jeg er helsepersonell", "Jeg er pårørende"]
    
    static let surveys = ["https://no.surveymonkey.com/r/VC9RY62", "https://no.surveymonkey.com/r/2RZ29SM", "https://no.surveymonkey.com/r/SGKKT2R"]
    static let surveyAchievementTitles = ["Første undersøkelse utført!", "Andre undersøkelse utført!", "Tredje undersøkelse utført!"]
    static let surveyAchievmentInfos = ["Første undersøkelse gjennomført, takk for at du deltok!", "Andre undersøkelse gjennomført, takk for at du deltok!", "Tredje undersøkelse gjennomført, takk for at du deltok!"]

    static let triggers = [
        TriggerStruct(title: "Mett", imageName: "AfterMeal", color: 0xfac174FF),
        TriggerStruct(title: "Sint", imageName: "Anger", color: 0xc03145FF),
        TriggerStruct(title: "Kjedsomhet", imageName: "Bored", color: 0x99a370FF),
        TriggerStruct(title: "Drikke", imageName: "Coffee_Tea", color: 0x51d5c0FF),
        TriggerStruct(title: "Romanse", imageName: "Date", color: 0xf1646cFF),
        TriggerStruct(title: "Alkohol", imageName: "Drinking", color: 0xa685a2FF),
        TriggerStruct(title: "Krangel", imageName: "Familiy", color: 0xa6dd59FF),
        TriggerStruct(title: "Trist", imageName: "FeelingDown", color: 0x749da6FF),
        TriggerStruct(title: "Venner", imageName: "Friends", color: 0xbaffc9FF),
        TriggerStruct(title: "Spill", imageName: "Games", color: 0x8cc168FF),
        TriggerStruct(title: "Glad", imageName: "Happy", color: 0xfad54fFF),
        TriggerStruct(title: "Sulten", imageName: "Hungry", color: 0xfadab7FF),
        TriggerStruct(title: "Samtale", imageName: "OnThePhone", color: 0x2dc080FF),
        TriggerStruct(title: "Fest", imageName: "Party", color: 0xb582faFF),
        TriggerStruct(title: "PC", imageName: "PC", color: 0x28a690FF),
        TriggerStruct(title: "Lesing", imageName: "Reading", color: 0xd68572FF),
        TriggerStruct(title: "Sliten", imageName: "Tired", color: 0x9dd5c0FF),
        TriggerStruct(title: "Rutine", imageName: "Rutine", color: 0xf39051FF),
        TriggerStruct(title: "Sex", imageName: "Sex", color: 0xf39cc3FF),
        TriggerStruct(title: "Stressa", imageName: "Stressed", color: 0x27a4ddFF),
        TriggerStruct(title: "Media", imageName: "TV", color: 0x8cd8faFF),
        TriggerStruct(title: "Tur", imageName: "Walking", color: 0xbcf59fFF),
        TriggerStruct(title: "Jobb", imageName: "Work", color: 0x6f8a09FF),
        TriggerStruct(title: "Redd", imageName: "Scared", color: 0x4880a6FF),
        
        TriggerStruct(title: "Kino", imageName: "Movie", color: 0x59ddc7FF),
        TriggerStruct(title: "Økonomi", imageName: "Economy", color: 0x59dd8aFF),
        TriggerStruct(title: "Kveldstid", imageName: "Evening", color: 0xbae1ffFF),
        TriggerStruct(title: "Eksponering", imageName: "Exposure", color: 0xc3cb71FF),
        TriggerStruct(title: "Ensom", imageName: "Lonely", color: 0x5a5255FF),
        TriggerStruct(title: "Møte", imageName: "Meeting", color: 0x84869fFF),
        TriggerStruct(title: "Morgen", imageName: "Morning", color: 0xffb3baFF),
        TriggerStruct(title: "Rastløs", imageName: "Restless", color: 0xf2654eFF),
        TriggerStruct(title: "Belønning", imageName: "Reward", color: 0xbbf29bFF),
        TriggerStruct(title: "Trening", imageName: "Training", color: 0xffffbaFF),
        TriggerStruct(title: "Været", imageName: "Weather", color: 0xb8dbd3FF),
        TriggerStruct(title: "Angst", imageName: "Anxiety", color: 0x9c5d6eFF),
        TriggerStruct(title: "Musikk", imageName: "Music", color: 0x8cd8faFF),
        TriggerStruct(title: "Søvn", imageName: "Sleep", color: 0x779ecbFF),
        TriggerStruct(title: "Ferie", imageName: "Vacation", color: 0xfed1dbFF),
        TriggerStruct(title: "Syk", imageName: "Sick", color: 0x7e9583FF),
        TriggerStruct(title: "Tomhet", imageName: "Emptyness", color: 0xb6a5c7FF)
    ]
    
    static let dailyThemes = [
        "Det er vanlig å oppleve noe ubehag helt i starten av slutteprossessen. Dette kan være svetting, rastløshet, dårlig matlyst og søvnproblemer.\n\nHva kan du selv gjøre for å dempe og lindre ubehaget? \nHva har du gjort tidligere som har fungert når du har hatt pauser?",
        
        "De fysiske abstinenssymptomene er sterkest første uka du slutter og kan vare i rundt 2–3 uker. Søvnproblemer, mareritt og russug kan vare noe lenger.\n\nHva tror du selv vil være bra å gjøre når du opplever spesifikke abstinenser?\nHar du opplevd andre utfordringer i livet og gjort konkrete ting som har hjulpet deg?",
        
        "Hva er dine hovedgrunner til at du har sluttet med cannabis?\nDet kan være nyttig å notere ned for deg selv de tre viktigste grunner til at du nå vil slutte med cannabis. Dersom dette programmet viser seg å være veldig vellykket, hvordan har du det om 8 uker? Skriv ned dine mål for slutteprosessen.",
        
        "Hvilke situasjoner, følelser og mennesker kan trigge lysten til å røyke? Hvem pleier du å røyke med?\n\nTenk gjennom hva du kan gjøre når suget kommer. Finnes det noen måter du kan avlede suget på når det er sterkt?\n\nDu kan lese om tips til å håndtere suget under informasjonsfanen.",
        
        "Hvordan skal du forholde deg til dine røykevenner i starten av slutteprosessen? Dette er viktig å tenke gjennom. Mange kan være ekstra sårbare de første ukene de har sluttet og det er lett å bli fristet til å røyke om de er sammen med andre som røyker.",
        
        "Har du prøvd å slutte før? Hva var motivasjonen din da? Hvilke strategier fungerte? Hva var det som gjorde at du begynte å røyke igjen (triggere / risikosituasjoner)? Sjekk gjerne ut triggerdagboken i appen, for å få en oversikt over hva du opplever at hjelper deg eller trigger deg.",
        
        "Husk at det du opplever av fysisk ubehag nå er abstinenssymptomer. Dette er kun en overgangsfase siden du har sluttet med cannabis. Det er ikke sånn du er som person når du ikke røyker. Det vil gå over og bli bedre. Hold ut! Når det har gått tre uker er du over kneika med fysiske abstinenssymptomer og angst.",
        
        "Øvelse En måte å forebygge sprekk ved russug, er å utforske egne tanker som kan bidra til tilbakefall. Et eksempel er å lage en unnskyldningsliste slik at du kan oppdage mulige tanker som kan bidra til sprekk. Tenk gjennom tre unnskyldninger du har hatt / kan ha som unnskyldning til å røyke.",
        
        "Er det noen interesser eller aktiviteter du ønsker å fordype deg i? Er det noen hobbyer du har drevet med før som du kunne tenke deg oppta?",
        
        "Hvilke risikosituasjoner (situasjoner som kan trigge suget etter å røyke) kan du unngå? Hvilke situasjoner er uungåelige? Hvordan kan du møte disse? Skriv gjerne ned strategier.",
        
        "Hva tror du at dine nærmeste synes om at du slutter med cannabis? Er det noen rundt deg du tror vil støtte deg i slutteprossesen?",
        
        "Har du merket noen endringer siden du sluttet? Legg merke til hvordan morgenen din er idag sammenlignet med når du røyket. Se om det er noen endringer i ditt energinivå, i måten du kommuniserer med andre på, hvordan du har det inni deg, hvordan du har det når du sitter på bussen, går ute, handler etc. Prøv å legge merke til været ute, omgivelsene dine, menneskene rundt deg, pusten din, tilstedeværelsen din her og nå.",
        
        "Gratulerer, du er kommet til fase 2! Det er vanlig å oppleve svingninger i humøret i denne fasen. Følelser kan forsterkes og det kan føre til at du noen ganger lettere overreagerer eller tar deg nær av det som blir sagt. Noen kan lettere havne i krangler eller konflikter med de nærmeste.",
        
        "Dersom du blir overmannet av sterke følelser eller angst, prøv å stoppe litt opp, puste dypt og tenk etter hva som skjer med deg. Ta et steg ut av situasjonen og forsøk å se deg selv utenfra. Minn deg selv på at følelsene ofte forsterkes og kan virke overveldene. Dette skjer fordi THC er på vei ut av kroppen og ikke lenger har en dempende virkning på følelsene. Følelser vil derfor velte “usortert” ut. Dette er ikke deg som person, men abstinenssymptomer. Hold ut. Følelsene vil roe seg mer når du kommer over i fase 3 (fra Dag 22).",
        
        "Det kan være lurt å utsette å ta store avgjørelser. Ta en dag av gangen. Husk at det vil bli bedre.",
        
        "Legg merke til følelsene dine. I hvilke situasjoner oppstår de? Hva slags intensitet er det? Hva gjør de med deg? På hvilken måte styrer de handlingene dine? Legg merke til gode løsningsstrategier.",
        
        "Om du opplever at du blir overmannet av negative tanker rundt en hendelse eller situasjon, kan du forsøke å stille spørsmålene Er mine tanker om situasjonen rimelige? Finnes det noen alternative måter å tolke situasjonen på?  De tanker man gjør seg om en hendelse påvirker hvordan man føler det, kroppslige fornemmelser og atferd.",
        
        "Hvilken følelse har du kjent mest på de siste dagene? Hvordan uttrykker du denne følelsen (ansiktsuttrykk, ord, kroppsspråk)? Hvor kjenner du den i kroppen din? Hvilken farge har den? Hva sier den?",
        
        "Det er vanlig å oppleve følelser av ensomhet, isolasjon, forlatthet og sinne i denne fasen, men også øyeblikk av lykke og oppstemthet.",
        
        "Merker du noen forandringer i måten som du fungerer på? Hvordan er din hjemmesituasjon (med samboer, foreldre, venner)?",
        
        "På en scala fra 0–5 hvor 0= ”svært misfornøyd” og 5= “veldig fornøyd”, totalt sett hvor fornøyd er du med livet ditt nå?",
        
        "Gratulerer, du har kommet til fase 3! Denne fasen handler om å bygge nettverk og identitet, og fokusere på fremtiden. Her jobber vi for å forhindre tilbakefall.",
        
        "En del merker at konsentrasjonen og oppmerksomheten blir bedre etter 3 til 4 uker. Har du merket noen bedringer?",
        
        "Noen kan slite med å finne ord til å beskrive hva de tenker og føler når det røyker. Mange opplever en bedring ved å slutte. Legg merke til om du finner ordene lettere og klarer å beskrive bedre hva du tenker og føler.",
        
        "Kortidshukommelsen kan bli dårligere når man røyker cannabis over tid. Ofte vil man merke at denne blir bedre og normaliseres etter 4–8 uker.",
        
        "Rutinene kan skli ut når man røyker mye cannabis over tid. Mange opplever at rutiner kommer naturlig tilbake når de slutter og trives med å få mer rutiner i hverdagen. Har du en rutine som er viktig for deg? Merker du at det har blitt lettere å komme inn i små rutiner som å pusse tenner om kvelden og å stå opp til samme tid?",
        
        "Husk tilbake på dine hovedmotivasjoner som du hadde for å slutte med cannabis. Hva er hovedgrunnen til at du vil fortsette å slutte? Har det kommet noen nye grunner til at du vil opprettholde sluttingen?",
        
        "Hva er du fornøyd med ved deg selv? Hvilke ressurser har du som har hjulpet deg i denne slutteprosessen?",
        
        "Har du merket forskjell på hvordan du kommuniserer med andre? Merker du noe annerledes når du snakker med venner / kollegaer / familie / kjæreste? Ofte vil kommunikasjonen med andre endre seg ved at man lytter og tenker mer før man snakker.",
        
        "Hvordan er det når du snakker med dine røykevenner? Ofte kan det bli mye monolog fremfor dialog når man røyker.",
        
        "Hva er dine tre viktigste mål for de neste seks månedene?",
        
        "Dersom du skulle velge en verdi og ta med deg videre i livet ditt, hvilken velger du? Skriv ned tre viktige verdier for deg.",
        
        "Hvem ønsker du å ha nærere i livet ditt, og hvem ønsker du å være mindre sammen med? Hvilke venner er røykevenner og hvem av dem kan du gjøre andre ting sammen med? Er det noen personer som har vært viktige tidligere i livet som du kan ta kontakt med igjen?",
        
        "Hvordan skal du forholde deg til de i ditt nettverk som bruker cannabis? Noen kan oppleve sorg og negative sider ved tap av nettverk når de tar et valg om å slutte eller ha en lengre pause i cannabisbruken. Hvordan er dette for deg? Finnes det noen andre arenaer i ditt liv hvor du kan bli kjent med andre mennesker? (skole, jobb, hobbyer).",
        
        "Er det noen personer i livet ditt som du beundrer? Hva er det med disse som er viktig for deg?",
        
        "Hvordan opplever du at du fungerer i hverdagen? Føler du at du hører hjemme i samfunnet? Merker du endringer i måten å fungere på?",
        
        "Hvilke personer i livet ditt er viktige for deg? Hvem ønsker du å ha mer kontakt med? Er det noen personer du ønsker å ta mer avstand til?",
        
        "Merker du noen endringer ved deg selv nå sammenlignet med når du røyket? Dette kan for eksempel være hvordan du har det, hvordan du fungerer i hverdagen, eller hvordan du er sammen med andre mennesker. Har dine foreldre, venner, kollegaer, kjæreste lagt merke til noen forandringer ved deg?",
        
        "Hvilke venner er det som gir deg positiv energi, støtte og utfordringer? Er det noen venner som ikke er bra for deg?",
        
        "Tenk gjennom hva du kan gjøre for å ha mer kontakt med de i livet som er bra for deg.",
        
        "Ofte kan det oppstå et tomrom når man slutter med cannabis. For mange har cannabis vært en nær venn. Derfor er det viktig å fokusere på nytt innhold i livet. Har du funnet en ny hobby eller aktivitet? Hva liker du å gjøre? Hva gir deg god energi? Er det noe du er nysgjerrig på som du kunne tenke deg å starte med?",
        
        "Ofte kan tidsopplevelsen endre seg i løpet av slutteprosessen, noen vil kunne oppleve at ting går raskere eller tregere.",
        
        "Hva innebærer glede for deg? Hva gjør deg glad? Legg merke til hva som gjør deg glad i løpet av en dag. Hvordan kommer gleden til uttrykk hos deg? Hvilken farge har gleden, hvor i kroppen sitter den, hva sier den?",
        
        "Tenk gjennom tre gode egenskaper / ressurser som du har. Hva sier dine nærmeste at de liker best ved deg?",
        
        "Når man slutter med cannabis trenger noen å finne tilbake til sin gamle identitet eller skape en ny identitet. Hvem var du før du begynte å røyke cannabis? Hvem ønsker du å være?",
        
        "Noen kan bli utålmodige og rastløse i denne fasen og ønske å få på plass alt i livet på en gang. Her er det viktig å ta en ting om gangen og prøve å være tålmodig.",
        
        "Har du merket noen forskjeller ved deg selv siden du slutta med cannabis? Hvordan hadde du det for en uke siden sammenlignet med nå? Hva er den viktigste endringen du opplever siden du sluttet?",
        
        "Mange opplever bedre konsentrasjon noen uker etter å ha sluttet med cannabis. Det vil bli lettere å forstå situasjoner i sammenheng, og lettere å løse konflikter. Hvordan er det for deg?",
        
        "Har du opplevd situasjoner og følelser hvor du vanligvis ville ha røyket, men hvor du gjorde noe annerledes? Hva gjorde du istedenfor å røyke? Hva var det i situasjonen som gjorde at du valgte annerledes? Var det noe du sa til deg selv eller tenkte? Hvordan føltes det å velge annerledes?",
        
        "Dersom du skrev ned noen mål du satte deg da du startet, finn fram disse nå. Har du nådd disse målene? Har noen av målene dine endret seg?",
        
        "Hvor ser du deg selv om fem år? Se flere spørsmål om mål for fremtiden under sosialt fokus.",
        
        "Hvilket verdier verdsetter du høyest fra din egen oppvekst og vil ta med deg videre? Hva vil du kvitte deg med? Hvordan vil du være mot andre og mot deg selv?",
        
        "Hvordan ser du for deg at ditt forhold til cannabis vil være i fremtiden? Prøv å se for deg hvordan livet ditt vil være med og uten cannabis.",
        
        "Cannabis kan for endel knyttes til ens identitet. Hva innebærer identitet for deg? Merker du noen endringer på din identitet før og nå?  Hvem var du når du røyket? Hvem er du nå? Hvem ønsker du å være?",
        
        "På en skala fra 0–5 hvor 0= ”svært misfornøyd” og 5= “veldig fornøyd”, totalt sett hvor fornøyd er du med livet ditt nå? Har du opplevd endring siden du sluttet?",
        
        "Gratulerer du har fullført hele programmet! Du har god grunn til å være stolt over deg selv!",
    ]
}

struct TriggerStruct{
    let title:String
    let imageName:String
    let color:Int64
}
