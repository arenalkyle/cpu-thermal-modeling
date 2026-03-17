# CPU Thermal Modeling & Monte Carlo Simulation

## Problem Statement
Computers rely on Central Processing Units (CPUs) which generate significant heat and must rely on a cooling system to dissipate this heat when under their intense workloads. If cooling is insufficient, it will go under thermal throttling, a process that reduces performance and in turn reduces heat generation. The problem faced and that this project will analyze/solve will be to depict a CPU’s temperature over time based on workloads, showing points where thermal throttling is enabled and performance becomes limited.


## Technical Overview

This project simulates the thermal characteristics of an Intel i7-12700K (modeled) paired with varying cooling solutions. It predicts temperature spikes, thermal throttling events, and maximum safe operational loads.

### Key Numerical Implementations:
* **Euler Method Integration:** Used to solve the first-order differential equation representing the thermal rate of change.
* **Bisection Method:** An iterative root-finding algorithm used to determine the exact "Maximum Safe Load" by solving the equilibrium temperature equation against the thermal ceiling (100°C).
* **Monte Carlo Analysis:** Runs $n=1000$ iterations with Gaussian noise applied to thermal resistance ($R_{th}$) and ambient temperature ($T_{amb}$) to simulate manufacturing tolerances and environmental changes.

---

## Project Structure

* `project.m`: The main entry point. Orchestrates the Monte Carlo loop, initializes CPU/Thermal parameters, and generates statistical summaries/plots.
* `eulerTempSim.m`: The core simulation engine. Handles the transient temperature state and implements **thermal throttling logic** (reducing load when `maxTemp` is reached).
* `calculateLoad.m`: A piecewise linear interpolation function that generates a dynamic CPU load profile over time.
* `bisection.m`: Iteratively finds the maximum load $L$ that satisfies $T_{eq} \leq 100°C$.
* `eqTemp.m`: Calculates steady-state equilibrium temperature based on power leakage and frequency scaling.

> [!NOTE]
> The `LoadProfileData` matrix in `calculateLoad.mlx` serves as the system's workload generator.
> To simulate different real-world usage patterns, users can custom define load-time pairs to emulate computational tasks or idle-to-peak transitions.
> 
---

## How to Run

1.  Clone the repository.
2.  Open `project.m` in MATLAB.
3.  Adjust CPU parameters (Power, Frequency) or Thermal parameters (Cooler quality via $\tau$) if desired.
4.  Run the script to generate:
    * **Statistical Summary:** Mean and Std Dev for Max Temperature, Safe Load, and Throttle onset.
    * **Visual Plot:** A time-series graph showing the CPU temperature curve and throttling recovery.

---

## Model Parameters (i7-12700K Profile)

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Frequency** | 3.6 GHz | Base clock speed |
| **Idle Power** | 30W | Power consumption at 0% load |
| **Max Power** | 190W | TDP / PL2 Power limit |
| **Max Temp** | 100°C | Thermal junction max (TjMax) |
| **$\tau$ (Tau)** | 10s | Thermal time constant of the cooler |
| **$R_{th}$** | 0.42 | Thermal resistance (C/W) |

---

## Results
### **First Results**
Match given code and parameters.
<img width="918" height="597" alt="image" src="https://github.com/user-attachments/assets/b6de93f5-0f8f-4d15-bff3-9b2845f48b46" />

| Metric | Mean Value | Standard Deviation ($\sigma$) |
| :--- | :--- | :--- |
| **Peak CPU Temperature** | 98.08 °C | 3.66 °C |
| **Max Safe Load (Steady State)** | 92% (0.92) | 8% (0.08) |
| **Total Throttle Duration** | 33.25 s | 42.61 s |

<br><br>

### **Second Results**
Changes:
* `tau = 5;` (from 10 down to 5)
* `thermalResist = .46;` (from .42 to .46)
<img width="923" height="599" alt="image" src="https://github.com/user-attachments/assets/96879954-c89e-44a4-99c1-1df2fe2c1463" />

| Metric | Mean Value | Standard Deviation ($\sigma$) |
| :--- | :--- | :--- |
| **Peak CPU Temperature** | 99.65 °C | 1.5 °C |
| **Max Safe Load (Steady State)** | 85% (0.85) | 9% (0.09) |
| **Total Throttle Duration** | 28.27 s | 12.19 s |

<br><br>

### **Third Results**
Changes:
* Revert `tau` and `thermalResist` to initial values, 10 and .42 respectively.
* `powerMax = 160;` (Reduced from 190 to 160)
* `idleTemp = 45;` (From 35 to 45)
* `roomTemp = 26;` (From 24 to 26)
<img width="934" height="592" alt="image" src="https://github.com/user-attachments/assets/35117ab5-729d-43e6-8158-39768ed48183" />

| Metric | Mean Value | Standard Deviation ($\sigma$) |
| :--- | :--- | :--- |
| **Peak CPU Temperature** | 95.49 °C | 5.49 °C |
| **Max Safe Load (Steady State)** | 97% (0.97) | 5% (0.05) |
| **Total Throttle Duration** | 14.05 s | 17.88 s |

<br><br>

---

## Analysis
Our results show that based on changing our values and simulating different boundaries and temperatures of CPUs under the same load, we can map out how the system’s temperature will react to load. Our load values can also be changed at the same time and we can view how they react differently based on load. A CPU should never reach its maximum temperature under any amount of load, that means that your cooler or the CPU is not sufficient enough for your tasks.<br> <br>
What we gain from this project is the ability to test CPUs and different loads on a system with different CPU coolers. This can be applied in real life where someone could be between purchasing a CPU and/or a CPU cooler, then use this program to see which would offer them the most benefits for their usage. This MATLAB code offers people a real-life solution to upgrading parts, visualizing load on their system, seeing how much energy consumption is used, and as well as view how temperature affects their computer’s output.

---

## Contact
I am a Computer Science senior focused on systems programming and low-level infrastructure.\
Please reach out to me at [kylearenal27@gmail.com](mailto:kylearenal27@gmail.com) with any questions or suggestions.
