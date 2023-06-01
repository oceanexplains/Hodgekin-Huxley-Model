import Foundation

// dv/dt: Calculates the change in membrane potential over time
func dvdt(gNa: Double, ENa: Double, m: Double, h: Double, gK: Double, EK: Double, n: Double, gL: Double, EL: Double, I: Double, V: Double) -> Double {
    return -gNa * m * m * m * h * (v - ENa) - gK * n * n * n * n * (v - EK) - gL * (v - EL) + I
}

// dm/dt: Calculates the rate of change for the gating variable m
func dmdt(alpha_m: Double, beta_m: Double, m: Double) -> Double {
    return alpha_m * (1 - m) - beta_m * m
}

// dn/dt: Calculates the rate of change for the gating variable n
func dndt(alpha_n: Double, beta_n: Double, n: Double) -> Double {
    return alpha_n * (1 - n) - beta_n * n
}

// dh/dt: Calculates the rate of change for the gating variable h
func dhdt(alpha_h: Double, beta_h: Double, h: Double) -> Double {
    return alpha_h * (1 - h) - beta_h * h
}

// Runge-Kutta method: Implements the fourth-order Runge-Kutta method for numerical integration
func rungeKutta4(h: Double, v: Double, variable: Double, alpha: (Double) -> Double, beta: (Double) -> Double) -> Double {
    let alpha_v = alpha(v)
    let beta_v = beta(v)
    
    let k1 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable)
    let k2 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + 0.5 * k1)
    let k3 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + 0.5 * k2)
    let k4 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + k3)

    return variable + (1.0 / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4)
}

// dVariable/dt: Calculates the rate of change for a given gating variable
func dVariabledt(alpha: Double, beta: Double, variable: Double) -> Double {
    return alpha * (1 - variable) - beta * variable
}

// Alpha functions for gating variables
func alphaM(v: Double) -> Double {
    return 0.1 * (25.0 - v) / (exp((25.0 - v) / 10.0) - 1.0)
}

func betaM(v: Double) -> Double {
    return 4.0 * exp(-v / 18.0)
}

func alphaN(v: Double) -> Double {
    return 0.01 * (10.0 - v) / (exp((10.0 - v) / 10.0) - 1.0)
}

func betaN(v: Double) -> Double {
    return 0.125 * exp(-v / 80.0)
}

func alphaH(v: Double) -> Double {
    return 0.07 * exp(-v / 20.0)
}

func betaH(v: Double) -> Double {
    return 1.0 / (exp((30.0 - v) / 10.0) + 1.0)
}


// Usage
let new_m = rungeKutta4(h: h, v: v, variable: m, alpha: alphaM, beta: betaM)
let new_n = rungeKutta4(h: h, v: v, variable: n, alpha: alphaN, beta: betaN)
let new_h = rungeKutta4(h: h, v: v, variable: h, alpha: alphaH, beta: betaH)


// Constants
let gNa = 120.0
let gK = 36.0
let gL = 0.3
let ENa = 115.0
let EK = -12.0
let EL = 10.613
let I = 10.0 // Vary this as required

// Initial values
var v = 0.0, m = 0.05, n = 0.32, h = 0.59

// Time simulation
let tStart = 0.0
let tEnd = 50.0
let dt = 0.01
let tRange = stride(from: tStart, to: tEnd, by: dt)

// Simulation data (initial conditions)
var data = [(t: Double, v: Double, m: Double, n: Double, h: Double)]()
data.append((t: tStart, v: v, m: m, n: n, h: h))

// Time evolution
for t in tRange {
    m = rungeKutta4(h: dt, v: v, variable: m, alpha: alphaM, beta: betaM)
    n = rungeKutta4(h: dt, v: v, variable: n, alpha: alphaN, beta: betaN)
    h = rungeKutta4(h: dt, v: v, variable: h, alpha: alphaH, beta: betaH)
    
    let dv = dvdt(gNa: gNa, ENa: ENa, m: m, h: h, gK: gK, EK: EK, n: n, gL: gL, EL: EL, I: I, V: v)
    v += dv * dt
    
    data.append((t: t, v: v, m: m, n: n, h: h))
}

// Now, `data` contains the time evolution of the system.
print(data)
