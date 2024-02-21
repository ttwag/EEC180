# Digital Circuit

## Digital Circuit in CMOS

Why do we care?
1. **Delay** - Estimate and improve the circuit's performance.
2. **Die size** - Cost of the circuit.
3. **Power** - Estimate power consumption.

### Switch Model
* ON and OFF switches can represent boolean variables.
* Switch can build all digital logic gates.
* CMOS technology has the lowest power consumption.
* CMOS Scaling leads to lower cost, improved performance, and the same power consumption.
* PMOS is good at passing a 1 but not 0, and vice versa for NMOS. Therefore, using both of them could create a near-perfect switch.
* nMOS transistor-based switch is ON when x = 1 and OFF when x = 0
    * Good for passing a 0, signals degrades by Vth for a 1.
* pMOS transistor-based switch is ON when x = 0 and OFF when x = 1
    * Good for passing a 1, the signal degrades by Vth for a 0.



### CMOS Layout

**Static CMOS**
* Pull Up (PMOS) and Pull Down Network (NMOS)**
* Lower cost.
* Less Power.
* Can only implement monotonically decreasing function (Input increase, output stays or decreases).
* Gives clean 1 and 0.

### Pull-Up Pull-Down Network
* Dual of a Boolean function is obtained by replacing AND by OR and 0 by 1 and OR by AND and 1 by 0.

**Switch Network**
* Uses switches to route input to output for the boolean function.
* Susceptible to input noise.

### Fanout
* Clocks, Resets, inputs and other global signals can fanout to 1000's inputs
* Delay will be significant.