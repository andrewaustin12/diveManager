import Foundation

import Foundation

//struct Course: Identifiable {
//    var id = UUID()
//    var students: [Student]
//    var startDate: Date
//    var endDate: Date
//    var sessions: [Session]
//    var diveShop: DiveShop?
//    var certificationAgency: CertificationAgency?
//    var isCompleted: Bool
//}

import Foundation

import Foundation

struct Course: Identifiable, Hashable, Equatable {
    var id = UUID()
    var students: [Student]
    var startDate: Date
    var endDate: Date
    var sessions: [Session]
    var diveShop: DiveShop?
    var certificationAgency: CertificationAgency
    var selectedCourse: String
    var isCompleted: Bool

    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}






//enum certificationAgency: String, CaseIterable, Codable {
//    case padi
//    case ssi
//    case sdi
//    case tdi
//    case raid
//    case naui
//    
//    enum PADI: String, CaseIterable {
//        case openWater = "Open Water Diver"
//        case advancedOpenWater = "Advanced Open Water Diver"
//        case rescueDiver = "Rescue Diver"
//        case divemaster = "Divemaster"
//        case enrichedAirDiver = "Nitrox Specialty"
//        case masterScubaDiver = "Master Scuba Diver"
//        case assistantInstructor = "Assistant Instructor"
//        case instructorDevelopmentCourse = "Instructor Development Course"
//        case masterInstructor = "Master Instructor"
//        case reActivateProgram = "ReActivate Program"
//        case diveTheory = "Dive Theory"
//        case deepDiver = "Deep Diver"
//        case wreckDiver = "Wreck Diver"
//        case nightDiver = "Night Diver"
//        case driftDiver = "Drift Diver"
//        case underwaterPhotographer = "Underwater Photographer"
//        case underwaterNavigator = "Underwater Navigator"
//        case boatDiver = "Boat Diver"
//        case peakPerformanceBuoyancy = "Peak Performance Buoyancy"
//        case underwaterNaturalist = "Underwater Naturalist"
//        case searchAndRecoveryDiver = "Search and Recovery Diver"
//        case underwaterVideographer = "Underwater Videographer"
//        case fishIdentification = "Fish Identification"
//        case underwaterArchaeologist = "Underwater Archaeologist"
//        case multilevelDiver = "Multilevel Diver"
//        case iceDiver = "Ice Diver"
//        case equipmentSpecialist = "Equipment Specialist"
//        case digitalUnderwaterPhotography = "Digital Underwater Photography"
//        case underwaterVideography = "Underwater Videography"
//        case selfReliantDiver = "Self-Reliant Diver"
//        case sidemountDiver = "Sidemount Diver"
//        case tecSidemountDiver = "Tec Sidemount Diver"
//        case tecSidemountInstructor = "Tec Sidemount Instructory"
//        case discoverTechnicalDiving = "Discover Technical Diving"
//        case tecBasics = "Tec Basics"
//        case tec40 = "Tec 40"
//        case tec40trimix = "Tec 40 Trimix"
//        case tec45 = "Tec 45"
//        case tec45trimix = "Tec 45 Trimix"
//        case tec50 = "Tec 50"
//        case tec50Trimix = "Tec 50 Trimix"
//        case tecTrimix65 = "Tec 65 Trimix"
//        case tecTrimixDiver = "Tec Trimix Diver"
//        case discoverRebreatherProgram = "Discover Rebreather Program"
//        case rebreatherDiver = "Rebreather Diver"
//        case tec40ccr = "Tec 40 CCR"
//        case tec60ccr = "Tec 60 CCR"
//        case tec100ccr = "Tec 100 CCR"
//        case advancedRebreatherDiver = "Advanced Rebreather Diver"
//        case tecGasBlender = "Tec Gas Blender"
//        case tecRecGasBlenderInstructor = "TecRec Gas Blender Instructor"
//        case tec40Instructor = "Tec 40 Instructor"
//        case tec40trimixInstructor = "Tec 40 Trimix Instructor"
//        case tec45Instructor = "Tec 45 Instructor"
//        case tec45trimixInstructor = "Tec 45 Trimix Instructor"
//        case tec50Instructor = "Tec 50 Instructor"
//        case tec50trimixInstructor = "Tec 50 Trimix Instructor"
//        case tecTrimixInstructor = "Tec Trimix Instructor"
//        case tec40ccrInstructor = "Tec 40 CCR Instructor"
//        case tec60ccrInstructor = "Tec 60 CCR Instructor"
//        case tec100ccrInstructor = "Tec 100 CCR Instructor"
//        case tecInstructorTrainer = "Tec Instructor Trainer"
//        // Add more PADI courses as needed
//    }
//
//
//    
//    enum SSI: String, CaseIterable {
//        case tryScuba = "Try Scuba"
//        case basicDiver = "Basic Diver"
//        case openWaterDiver = "Open Water Diver"
//        case advancedAdventurer = "Advanced Adventurer"
//        case stressAndRescue = "Stress and Rescue"
//        case divemaster = "Divemaster"
//        case enrichedAirNitrox = "Enriched Air Nitrox"
//        case masterDiver = "Master Diver"
//        case diveControlSpecialist = "Dive Control Specialist"
//        case diveGuide = "Dive Guide"
//        case assistantInstructor = "Assistant Instructor"
//        case diveControlSpecialistInstructor = "Dive Control Specialist Instructor"
//        case openWaterInstructor = "Open Water Instructor"
//        case advancedOpenWaterInstructor = "Advanced Open Water Instructor"
//        case diveConInstructor = "Dive Con Instructor"
//        case stressAndRescueInstructor = "Stress and Rescue Instructor"
//        case masterDiverInstructor = "Master Diver Instructor"
//        case scienceOfDiving = "Science of Diving"
//        case navigation = "Navigation"
//        case deepDiving = "Deep Diving"
//        case nightAndLimitedVisibility = "Night and Limited Visibility"
//        case boatDiving = "Boat Diving"
//        case perfectBuoyancy = "Perfect Buoyancy"
//        case drySuitDiving = "Dry Suit Diving"
//        case equipmentTechniques = "Equipment Techniques"
//        case underwaterPhotography = "Underwater Photography"
//        case wreckDiving = "Wreck Diving"
//        case searchAndRecovery = "Search and Recovery"
//        case waveTidesAndCurrents = "Waves, Tides and Currents"
//        case ecology = "Ecology"
//        case firstAidAndCPR = "First Aid and CPR"
//        case oxygenProvider = "Oxygen Provider"
//        case snorkeling = "Snorkeling"
//        // Add more SSI courses as needed
//    }
//    
//    enum SDI: String, CaseIterable {
//        case openWaterScubaDiver = "Open Water Scuba Diver"
//        case advancedAdventureDiver = "Advanced Adventure Diver"
//        case rescueDiver = "Rescue Diver"
//        case divemaster = "Divemaster"
//        case nitroxDiver = "Nitrox Diver"
//        case masterScubaDiver = "Master Scuba Diver"
//        case assistantInstructor = "Assistant Instructor"
//        case instructor = "Instructor"
//        case openWaterSidemountDiver = "Open Water Sidemount Diver"
//        case wreckDiver = "Wreck Diver"
//        case deepDiver = "Deep Diver"
//        case underwaterNavigation = "Underwater Navigation"
//        case nightAndLimitedVisibilityDiver = "Night and Limited Visibility Diver"
//        case computerDiver = "Computer Diver"
//        case boatDiver = "Boat Diver"
//        case drysuitDiver = "Dry Suit Diver"
//        case altitudeDiver = "Altitude Diver"
//        case driftDiver = "Drift Diver"
//        case iceDiver = "Ice Diver"
//        case fullFaceMaskDiver = "Full Face Mask Diver"
//        case underwaterPhotography = "Underwater Photography"
//        case underwaterVideography = "Underwater Videography"
//        case searchAndRecoveryDiver = "Search and Recovery Diver"
//        case soloDiver = "Solo Diver"
//        case recreationalTrimixDiver = "Recreational Trimix Diver"
//        case diveAgainstDebris = "Dive Against Debris"
//        case nightHuntingAndCollecting = "Night Hunting and Collecting"
//        case advancedBuoyancyControl = "Advanced Buoyancy Control"
//        case marineEcosystemsAwareness = "Marine Ecosystems Awareness"
//        // Add more SSI courses as needed
//    }
//    
//    enum TDI: String, CaseIterable {
//        case nitroxDiver = "Nitrox Diver"
//        case advancedNitroxDiver = "Advanced Nitrox Diver"
//        case decompressionProceduresDiver = "Decompression Procedures Diver"
//        case extendedRangeDiver = "Extended Range Diver"
//        case trimixDiver = "Trimix Diver"
//        case advancedGasBlender = "Advanced Gas Blender"
//        case entryLevelTrimixDiver = "Entry Level Trimix Diver"
//        case cavernDiver = "Cavern Diver"
//        case introToTech = "Intro to Tech"
//        case sidemountDiver = "Sidemount Diver"
//        case advancedWreckDiver = "Advanced Wreck Diver"
//        case advancedGasBlenderInstructor = "Advanced Gas Blender Instructor"
//        case decompressionProceduresInstructor = "Decompression Procedures Instructor"
//        case extendedRangeInstructor = "Extended Range Instructor"
//        case trimixInstructor = "Trimix Instructor"
//        case entryLevelTrimixInstructor = "Entry Level Trimix Instructor"
//        case cavernInstructor = "Cavern Instructor"
//        case advancedWreckInstructor = "Advanced Wreck Instructor"
//        case technicalDivingInstructor = "Technical Diving Instructor"
//        case technicalDivingInstructorTrainer = "Technical Diving Instructor Trainer"
//        // Add more SSI courses as needed
//    }
//    
//    enum RAID: String, CaseIterable {
//        case openWaterDiver = "Open Water Diver"
//        case advanced35Diver = "Advanced 35 Diver"
//        case rescueDiver = "Rescue Diver"
//        case divemaster = "Dive Master"
//        case nitroxDiver = "Nitrox Diver"
//        case masterRescueDiver = "Master Rescue Diver"
//        case diveMedic = "Dive Medic"
//        case oxygenProvider = "Oxygen Provider"
//        case explorer35 = "Explorer 35"
//        case explorer40 = "Explorer 40"
//        case explorer45 = "Explorer 45"
//        case deep35 = "Deep 35"
//        case deep40 = "Deep 40"
//        case deep45 = "Deep 45"
//        case wreck35 = "Wreck 35"
//        case wreck40 = "Wreck 40"
//        case wreck45 = "Wreck 45"
//        case night35 = "Night 35"
//        case night40 = "Night 40"
//        case night45 = "Night 45"
//        case navigation35 = "Navigation 35"
//        case navigation40 = "Navigation 40"
//        case navigation45 = "Navigation 45"
//        case drysuit35 = "Drysuit 35"
//        case drysuit40 = "Drysuit 40"
//        case drysuit45 = "Drysuit 45"
//        case sidemount35 = "Sidemount 35"
//        case sidemount40 = "Sidemount 40"
//        case sidemount45 = "Sidemount 45"
//        case iceDiver = "Ice Diver"
//        case rebreatherExperience = "Rebreather Experience"
//        // Add more SSI courses as needed
//    }
//    
//    enum NAUI: String, CaseIterable {
//        case scubaDiver = "Scuba Diver"
//        case advancedScubaDiver = "Advanced Scuba Diver"
//        case masterScubaDiver = "Master Scuba Diver"
//        case rescueDiver = "Rescue Diver"
//        case divemaster = "Divemaster"
//        case assistantInstructor = "Assistant Instructor"
//        case instructor = "Instructor"
//        case instructorTrainer = "Instructor Trainer"
//        case diveSafetyOfficer = "Dive Safety Officer"
//        case nitroxDiver = "Nitrox Diver"
//        case scientificDiver = "Scientific Diver"
//        case underwaterEcologist = "Underwater Ecologist"
//        case underwaterArcheologist = "Underwater Archeologist"
//        case underwaterEnvironment = "Underwater Environment"
//        case underwaterPhotographer = "Underwater Photographer"
//        case underwaterVideographer = "Underwater Videographer"
//        case iceDiver = "Ice Diver"
//        case drySuitDiver = "Dry Suit Diver"
//        case searchAndRecoveryDiver = "Search and Recovery Diver"
//        case caveDiver = "Cave Diver"
//        case cavernDiver = "Cavern Diver"
//        case introToTechDiving = "Intro to Tech Diving"
//        case trimixDiver = "Trimix Diver"
//        case rebreatherDiver = "Rebreather Diver"
//        case wreckDiver = "Wreck Diver"
//        case nightDiver = "Night Diver"
//        case deepDiver = "Deep Diver"
//        case underwaterNavigation = "Underwater Navigation"
//        // Add more NAUI courses as needed
//    }
//    
//    // Function to get courses based on the selected agency
//    func getCourses() -> [String] {
//        switch self {
//        case .padi:
//            return PADI.allCases.map { $0.rawValue }
//        case .ssi:
//            return SSI.allCases.map { $0.rawValue }
//        case .sdi:
//            return SDI.allCases.map { $0.rawValue }
//        case .tdi:
//            return TDI.allCases.map { $0.rawValue }
//        case .raid:
//            return RAID.allCases.map { $0.rawValue }
//        case .naui:
//            return NAUI.allCases.map { $0.rawValue }
//        }
//    }
//}
