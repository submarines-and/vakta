//
//  Enums.swift
//  Vakta
//
//  Created by Johannes Sörensen on 2021-03-28.
//

enum DispatchSelectors: Int {
    case
        kOpen = 0,
        kClose,
        kSetMuxState,
        kGetMuxState,
        kSetExclusive,
        kDumpState,
        kUploadEDID,
        kGetAGCData,
        kGetAGCData_log1,
        kGetAGCData_log2,
        kNumberOfMethods
};

enum GPU_INT: Int {
    case
        Discrete = 0,
        Integrated
}

enum GPUState : Int {
    case
        // get: returns a uint64_t with bits set according to FeatureInfos, 1=enabled
        DisableFeatureORFeatureInfo        = 0,
        
        // get: same as FeatureInfo
        EnableFeatureORFeatureInfo2        = 1,
        
        // set: force Graphics Switch regardless of switching mode
        // get: always returns 0xdeadbeef
        ForceSwitch                        = 2,
        
        // set: power down a gpu, pretty useless since you can't power down the igp and the dedicated gpu is powered down automatically
        // get: maybe returns powered on graphics cards, 0x8 = integrated, 0x88 = discrete (or probably both, since integrated never gets powered down?)
        PowerGPU                           = 3,
        
        // set/get: Dynamic Switching on/off with [2] = 0/1
        GpuSelect                          = 4,
        
        // set: 0 = dynamic switching, 2 = no dynamic switching, exactly like older mbp switching, 3 = no dynamic stuck, others unsupported
        // get: possibly inverted?
        SwitchPolicy                       = 5,
        
        // get: always 0xdeadbeef
        Unknown                            = 6,
        
        // get: returns active graphics card
        GraphicsCard                       = 7,
        
        // get: sometimes 0xffffffff, TODO: figure out what that means
        Unknown2                           = 8
}
