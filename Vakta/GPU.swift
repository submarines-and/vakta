//
//  GPU.swift
//  Vakta
//
//  Created by Johannes Sörensen on 2021-03-28.
//
import Cocoa


class GPU {
    static var global = GPU()
    
    init(){
        connect()
    }

    private var _connect: io_connect_t = IO_OBJECT_NULL;
    public var currentGPU: String?
    
    
    func connect() {
        var kernResult: kern_return_t = 0
        var service: io_service_t = IO_OBJECT_NULL
        var iterator: io_iterator_t = 0
        
        kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("AppleGraphicsControl"), &iterator);
        
        if kernResult != KERN_SUCCESS {
            print("IOServiceGetMatchingServices returned \(kernResult)")
        }
        
        service = IOIteratorNext(iterator);
        IOObjectRelease(iterator);
        
        if service == IO_OBJECT_NULL {
            print("No matching drivers found.");
            return
        }
        
        kernResult = IOServiceOpen(service, mach_task_self_, 0, &self._connect);
        if kernResult != KERN_SUCCESS {
            print("IOServiceOpen returned \(kernResult)");
            return
        }
        
        kernResult = IOConnectCallScalarMethod(self._connect, UInt32(DispatchSelectors.kOpen.rawValue), nil, 0, nil, nil);
        if kernResult != KERN_SUCCESS {
            print("IOConnectCallScalarMethod returned \(kernResult)")
            return
        }
        
        print("Successfully connected")
    }
    
    func IsUsingIntegrated() -> Bool {
        if self._connect == IO_OBJECT_NULL {
            print("Lost connection to gpu")
            return false
        }
        
        let gpu_int = GPU_INT(rawValue: Int(getGPUState(connect: self._connect, input: GPUState.GraphicsCard)))
        
      //  NotificationCenter.default.post(name: Notification.Name("checkGPUState"), object: gpu_int)
        return gpu_int == .Integrated
    }
    
    private func getGPUState(connect: io_connect_t, input: GPUState) -> UInt64 {
        var kernResult: kern_return_t = 0
        let scalar: [UInt64] = [ 1, UInt64(input.rawValue) ];
        var output: UInt64 = 0
        var outputCount: UInt32 = 1
        
        kernResult = IOConnectCallScalarMethod(
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
        
        var successMessage = "GET: count \(outputCount), value \(output)"
        
        if(input == .GraphicsCard) {
            let gpu_int = GPU_INT(rawValue: Int(output))!
            successMessage += " (\(gpu_int))"
        }
        
        if kernResult == KERN_SUCCESS {
         //   print(successMessage)
        }
        else {
            print("Get state returned \(kernResult)")
        }
        
        return output
    }
}
