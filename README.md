
# Implementing the Hodgkin-Huxley Model of the Neuron in Swift

## Introduction

The Hodgkin-Huxley model is a mathematical model that describes the behavior of neurons, specifically the generation and propagation of action potentials. It provides insights into the behavior of neurons and explains how they generate and propagate electrical signals, known as action potentials. This implementation is a practice I chose because of my interest in neuroscience and computational biology. Let's tak a closer look at how it works below by implementing it in Swift.


## Theoretical Background

The theoretical background section provides an overview of the Hodgkin-Huxley model, including its significance and the underlying principles. It explains the ion channels involved, such as sodium, potassium, and leakage channels, and their role in generating action potentials. Additionally, you can introduce the concept of the Nernst potential and its relevance to the model.

The Hodgkin-Huxley model is a mathematical model that helps us understand how neurons generate and transmit electrical signals, known as action potentials. It was developed by Alan Hodgkin and Andrew Huxley in the 1950s based on their groundbreaking experiments on the giant axons of squids.

### Neurons and Action Potentials
Neurons are specialized cells in our bodies that play a crucial role in transmitting information through electrical signals. These signals, called action potentials, allow neurons to communicate with each other and enable various functions in our bodies, including movement, perception, and memory.

### Ion Channels: Gatekeepers of Neuronal Excitability
To understand how neurons generate action potentials, we need to introduce the concept of ion channels. Ion channels are specialized proteins embedded in the cell membrane of neurons. These channels act as gatekeepers, controlling the flow of ions (charged particles) in and out of the neuron.

### The Hodgkin-Huxley Model: Unraveling Neuronal Behavior
The Hodgkin-Huxley model provides a mathematical framework for understanding how ion channels contribute to the generation and propagation of action potentials. It describes the behavior of four types of ion channels: sodium channels (Na+), potassium channels (K+), and leakage channels (representing other ions). Each of these channels has different properties and influences the electrical activity of the neuron.

### Gating Variables: Controlling Ion Channel Openings
One of the key concepts in the Hodgkin-Huxley model is the idea of gating variables. Gating variables represent the probabilities of ion channels being in an open or closed state. They are influenced by the voltage across the cell membrane and determine the conductance of the ion channels.

### Membrane Potential: The Electrical State of Neurons
The membrane potential is the voltage difference across the cell membrane of a neuron. It plays a crucial role in determining the excitability and firing behavior of neurons. In the Hodgkin-Huxley model, the membrane potential changes over time due to the flow of ions through the ion channels.

### Nernst Potential: Equilibrium Potential of Ions
The Nernst potential is the electrical potential at which the net flow of ions through an ion channel becomes zero. It represents the equilibrium point for an ion, where the electrical force pushing the ion in one direction is balanced by the concentration gradient pulling it in the opposite direction.

By understanding the behavior of ion channels, gating variables, and the membrane potential, we can use the Hodgkin-Huxley model to simulate and analyze the electrical activity of neurons. In the following sections, we will implement this model in Swift and explore its applications in computational neuroscience.



## Implementation
In this section, we will implement the Hodgkin-Huxley model in Swift, step by step. We will break down the implementation into smaller functions and explain their purpose along the way. By the end of this section, you will have a clear understanding of how the model is implemented and how the different components work together.

### Defining the Functions
#### dvdt: Calculating Membrane Potential Change
The first function we will define is dvdt. This function calculates the change in membrane potential over time. It takes various parameters such as conductance values, gating variables, equilibrium potentials, current input, and the current membrane potential. It applies the Hodgkin-Huxley equations to compute the rate of change of the membrane potential.

<pre>
func dvdt(gNa: Double, ENa: Double, m: Double, h: Double, gK: Double, EK: Double, n: Double, gL: Double, EL: Double, I: Double, V: Double) -> Double {
    return -gNa * m * m * m * h * (v - ENa) - gK * n * n * n * n * (v - EK) - gL * (v - EL) + I
}
</pre>

#### dmdt, dndt, dhdt: Calculating Gating Variable Rates
Next, we define three functions: dmdt, dndt, and dhdt. These functions calculate the rate of change for the gating variables m, n, and h, respectively. Each function takes the alpha and beta values specific to the respective gating variable and the current value of the gating variable. It applies the Hodgkin-Huxley equations to compute the rate of change.

<pre>
func dmdt(alpha_m: Double, beta_m: Double, m: Double) -> Double {
    return alpha_m * (1 - m) - beta_m * m
}

func dndt(alpha_n: Double, beta_n: Double, n: Double) -> Double {
    return alpha_n * (1 - n) - beta_n * n
}

func dhdt(alpha_h: Double, beta_h: Double, h: Double) -> Double {
    return alpha_h * (1 - h) - beta_h * h
}
</pre>

#### rungeKutta4: Numerical Integration
The next function we define is rungeKutta4. This function implements the fourth-order Runge-Kutta method for numerical integration. It takes the time step size h, the current membrane potential v, the current value of a gating variable, and the alpha and beta functions specific to that gating variable. It uses the Runge-Kutta method to approximate the value of the gating variable at the next time step.

<pre>
func rungeKutta4(h: Double, v: Double, variable: Double, alpha: (Double) -> Double, beta: (Double) -> Double) -> Double {
    let alpha_v = alpha(v)
    let beta_v = beta(v)
    
    let k1 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable)
    let k2 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + 0.5 * k1)
    let k3 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + 0.5 * k2)
    let k4 = h * dVariabledt(alpha: alpha_v, beta: beta_v, variable: variable + k3)

    return variable + (1.0 / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4)
}
</pre>

#### dVariabledt: Calculating Gating Variable Change
Lastly, we define the dVariabledt function. This function calculates the rate of change for a given gating variable. It takes the alpha and beta values specific to the gating variable, as well as the current value of the gating variable. It applies the Hodgkin-Huxley equations to compute the rate of change.


<pre>
func dVariabledt(alpha: Double, beta: Double, variable: Double) -> Double {
    return alpha * (1 - variable) - beta * variable
}
</pre>

#### Alpha and Beta Functions
To complete the implementation, we define the alpha and beta functions for each gating variable: alphaM, betaM, alphaN, betaN, alphaH, and betaH. These functions take the current membrane potential v and return the respective alpha or beta value based on the Hodgkin-Huxley equations.

<pre>
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
</pre>

When choosing the values for the functions in the Hodgkin-Huxley model, it is important to consider experimental data and empirical knowledge about what ou are studying because these vales can vary. The values used above are based on experimental measurements and fit the observed behavior of ion channels in neurons.

These values were determined by Hodgkin and Huxley through their extensive experiments on the giant axons of squids (google these, they're huge!). By carefully measuring the voltage-dependent behavior of ion channels, they derived the mathematical relationships that describe the kinetics of the gating variables. The alpha and beta functions capture the opening and closing rates of the ion channels as a function of the membrane potential.

Again: It's super important to note that these values are **specific to the squid giant axons** and may not be directly applicable to all types of neurons or species. However, they provide a foundational framework for understanding neuronal behavior so I've chosen to roll with them.

With all the necessary functions defined, we can now move on to implementing the simulation and running the Hodgkin-Huxley model.

## Simulating Neuronal Behavior
In this section, we will simulate the behavior of a neuron using the implemented Hodgkin-Huxley model. We will discuss the required constants, initial values, and time simulation parameters. By the end of this section, you will be able to run the simulation and observe the time evolution of the neuronal system.

### Constants
Before running the simulation, we need to define the necessary constants. These constants represent the conductance values, equilibrium potentials, and current input to the neuron. Modify these values as needed to simulate different scenarios.

<pre>
let gNa = 120.0
let gK = 36.0
let gL = 0.3
let ENa = 115.0
let EK = -12.0
let EL = 10.613
let I = 10.0 // Vary this as required
</pre>

### Initial Values
Next, we define the initial values for the membrane potential and the gating variables. These values represent the starting point of the simulation.

<pre>
var v = 0.0 // Membrane potential
var m = 0.05 // Gating variable m
var n = 0.32 // Gating variable n
var h = 0.59 // Gating variable h
</pre>

### Time Simulation
To simulate the behavior of the neuron over time, we need to define the time simulation parameters. These include the start time, end time, and the time step size (**dt**).

<pre>
let tStart = 0.0
let tEnd = 50.0
let dt = 0.01
let tRange = stride(from: tStart, to: tEnd, by: dt)
</pre>

### Simulation Data
We will store the simulation data, including the membrane potential and gating variables, in a data structure for further analysis and visualization. We initialize an empty array to store the data.

<pre>
var data = [(t: Double, v: Double, m: Double, n: Double, h: Double)]()
data.append((t: tStart, v: v, m: m, n: n, h: h))
</pre>

### Time Evolution
Now, we can run the simulation by iterating over the time range and updating the values of the gating variables and membrane potential using the Runge-Kutta method.

<pre>
for t in tRange {
    m = rungeKutta4(h: dt, v: v, variable: m, alpha: alphaM, beta: betaM)
    n = rungeKutta4(h: dt, v: v, variable: n, alpha: alphaN, beta: betaN)
    h = rungeKutta4(h: dt, v: v, variable: h, alpha: alphaH, beta: betaH)
    
    let dv = dvdt(gNa: gNa, ENa: ENa, m: m, h: h, gK: gK, EK: EK, n: n, gL: gL, EL: EL, I: I, V: v)
    v += dv * dt
    
    data.append((t: t, v: v, m: m, n: n, h: h))
}
</pre>

### Simulation Results
At the end of the simulation, the data array will contain the time evolution of the system, including the membrane potential (**v**) and the gating variables (**m, n, h**). You can further analyze and visualize this data to gain insights into the behavior of the neuron.

<pre>
print(data) // Output the simulation data
</pre>

In the future I may go about implementing a better visualization of this.


## Analyzing the Results
In this section, we will analyze the results obtained from simulating the Hodgkin-Huxley model. We will focus on the behavior of the membrane potential and its correlation to action potentials. Additionally, we will explore the role of the input current in influencing the firing behavior of the neuron.

### Membrane Potential Behavior
The membrane potential (**v**) represents the electrical state of the neuron. By analyzing the time evolution of the membrane potential, we can observe the changes in its voltage over time. Plotting the membrane potential against time can provide insights into the firing behavior of the neuron.

### Action Potentials
Action potentials are brief electrical signals generated by neurons that allow for rapid communication over long distances. They are characterized by a rapid depolarization followed by repolarization. In the simulation results, look for distinct patterns where the membrane potential spikes and returns to its resting state.

### Firing Threshold
The firing threshold is the level of membrane potential at which an action potential is triggered. By examining the membrane potential traces, identify the voltage level at which the neuron starts generating action potentials. This threshold can vary depending on factors such as the input current (**I**) and the conductance values (**gNa, gK, gL**).

### Role of Input Current
The input current (**I**) represents the external stimulus applied to the neuron. It plays a crucial role in determining the firing behavior of the neuron. By modifying the value of the input current, you can observe changes in the firing rate and patterns of the neuron.

### Subthreshold and Suprathreshold Stimuli
When the input current is below the firing threshold, it is considered a subthreshold stimulus. In this case, the neuron does not generate action potentials and remains in its resting state. On the other hand, when the input current exceeds the firing threshold, it is considered a suprathreshold stimulus. I'm considering building a UI to allow me to experiment with different subthreshold and suprethreshold current to play aorund and observe how the neuron behaves in response.


## Usage
Use this however you like! It was an exploration for me which I decided to turn into this tutorial of sorts here. I hpoe you liked it! If you want me to add anything, make an issue and I'll consider building out the UI!
