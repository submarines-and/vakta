//
//  GPU.swift
//  Vakta
//
//  Created by Johannes Sörensen on 2021-03-28.
//
import Cocoa


class GPU {
    static var global = GPU()
    
    private var _connection: io_connect_t = IO_OBJECT_NULL;
    
    init(){
        var kernResult: kern_return_t = 0
        var service: io_service_t = IO_OBJECT_NULL
        var iterator: io_iterator_t = 0
        
        kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("AppleGraphicsControl"), &iterator);
        
        if(kernResult != KERN_SUCCESS){
            return
        }
        
        service = IOIteratorNext(iterator);
        IOObjectRelease(iterator);
        
        if service == IO_OBJECT_NULL {
            return
        }
        
        kernResult = IOServiceOpen(service, mach_task_self_, 0, &self._connection);
        if kernResult != KERN_SUCCESS {
            return
        }
        
        kernResult = IOConnectCallScalarMethod(self._connection, UInt32(DispatchSelectors.kOpen.rawValue), nil, 0, nil, nil);
    }
    
      
    func IsUsingIntegrated() -> Bool {
        if self._connection == IO_OBJECT_NULL {
            return false
        }
        
        let gpu_int = GPU_INT(rawValue: Int(getGPUState(connect: self._connection, input: GPUState.GraphicsCard)))
        
        return gpu_int == .Integrated
    }
    
    private func getGPUState(connect: io_connect_t, input: GPUState) -> UInt64 {
        let scalar: [UInt64] = [ 1, UInt64(input.rawValue) ];
        var output: UInt64 = 0
        var outputCount: UInt32 = 1
        
        IOConnectCallScalarMethod(
            // an io_connect_t returned from IOServiceOpen().
            connect,
            
            // selector of the function to be called via the user client.
            UInt32(DispatchSelectors.kGetMuxState.rawValue),
            
            // array of scalar (64-bit) input values.
            scalar,
            
            // the number of scalar input values.
            2,
            
            // array of scalar (64-bit) output values.
            &output,
            
            // pointer to the number of scalar output values.
            &outputCount
        );
        
        return output
    }
}
