//
//  main.swift
//  7l_ChernikovOleg.playground
//
//  Created by Олег Черников on 21.03.2022.
//

import Foundation

enum CarBrands{
    case mitsubishi, dodge, toyota, lada
}

enum EngineStates{
    case running, off
}

enum WindowsStates{
    case up, down
}

enum GasTank: Int{
    case regular = 60
}

enum GasPerKm: Int{
    case city = 10
    case highway = 6
}

//Errors I'm going to use
enum CarError: Error{
    case outOfGas
    case engineIsOff
    case gasOverflow
}

class Car{
    let brand: CarBrands
    
    let tank: GasTank
    
    private var tankFilled: Int
    
    private var engine: EngineStates?
    
    private var mileage: Int
    
    private var engineState: EngineStates {
        willSet{
            if newValue == .running{
                print("Engine is running")
            }
            else{
                print("Engine is off")
            }
        }
    }
    private var windows: WindowsStates {
        willSet{
            if newValue == .up{
                print("Windows are up")
            }
            else{
                print("Windows are down")
            }
        }
    }
    
    init(brand: CarBrands, engine: EngineStates, windows: WindowsStates){
        self.brand = brand
        self.engineState = engine
        self.windows = windows
        
        self.tank = GasTank.regular
        self.tankFilled = 0
        self.mileage = 0
    }
    
    func engineControl(_ control:EngineStates){
            self.engineState = control
    }
    func windowsControl(_ control:WindowsStates){
        self.windows = control
    }
    func whatAreYou(){
        print("My brand is \(self.brand)")
        print("My engine is \(self.engineState)")
        print("My windows are \(self.windows)")
        print("Trunk is \(self.tankFilled) full")
        print("My mileage is \(self.mileage)kms")
    }
    
    //Func with errors:
    //First two funcs about trying to go somewhere:
    
    //Throwing
    private func going(cond: GasPerKm) throws{
        guard self.engineState != .off else{
            throw CarError.engineIsOff
        }
        guard self.tankFilled >= cond.rawValue else{
            self.engineState = .off
            throw CarError.outOfGas
        }
        self.tankFilled -= cond.rawValue
        self.mileage += 1
    }
    //Catching
    func ride(_ kms: UInt, _ cond: GasPerKm) -> String{
        do{
            for _ in 1...kms{
                try going(cond: cond)
            }
        } catch CarError.outOfGas {
            return "Car is out of gas"
        } catch CarError.engineIsOff{
            return "Cars' engine is off"
        } catch let error{
            return error.localizedDescription
        }
        return "Arrived at destination"
    }
    
    
    //Second two funcs about filling car with gas
    private func filling() throws{
        guard self.tankFilled < self.tank.rawValue else{
            throw CarError.gasOverflow
        }
        self.tankFilled += 1
    }
    
    func fillTank(_ litres: Int) -> String{
        do{
            for _ in 1...litres{
                try filling()
            }
        } catch CarError.gasOverflow{
            return "Tank overflows with gas"
        } catch let error{
            return error.localizedDescription
        }
        return "Done, tank is filled by \(self.tankFilled)"
    }
}

var mitsu = Car(brand: .mitsubishi, engine: .off, windows: .up)

//Engine is off
print(mitsu.ride(10, .city))

mitsu.engineControl(.running)

//No gas
print(mitsu.ride(10, .city))

//Overflow
print(mitsu.fillTank(65))
mitsu.engineControl(.running)

//Arrived
print(mitsu.ride(5, .city))

//No gas
print(mitsu.ride(2, .city))

//Mileage is 6km
mitsu.whatAreYou()
