#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge

/*#set text(
  font:"Verdana"
  )
  */
#set par(
  justify: true
  )
#set heading(
  numbering: "1."
  )
#set math.equation(
  numbering: "(1)"
  )

#place(
  horizon+center,
  box()[
    #set text(size:20pt)
    System Model Documentation
  ]
)


#pagebreak()
#outline(depth:2,indent:6pt)


#pagebreak()
= Introduction
This document describes the system model for the project.  The system model is a high-level representation of the system that shows the system's components and their interactions. The system model is used to communicate the system's structure and behavior.
\ \
HyPro ustilises object oriented programming (OOP), which means that a lot of things are different. One of the different things that it does is that it uses lots of blocks and functions to compartmentilise the parts of the system. This document will describe the blocks that are included in HyPro and how they interact with each other.
= Underlying Physics
== Thermophysical Properties
Data about the thermodynamic state of each species is required in order to characterise fluid behaviour, or any thermodynamic process. The standard approach to model is this use a library of least-squares coefficients that are used to calculate the thermophysical properties of the fluid. Coefficients from Cantera are used in HyPro to calculate the thermophysical properties of the fluid. The equations used to calculate the thermophysical properties of the fluid are as follows:

$ (C_p (T))/R=a_0 + a_1 T + a_2 T^2 + a_3 T^3 + a_4 T^4 $ <heat_capacity>

$ (H^0 (T))/(R T)=a_0 + a_1/2 T + a_2/3 T^2 +a_3/4 T^3 +a_4/5 T^4 + a_5/T $ <enthalpy>

$ (S^0 (T))/R = a_0 ln(T) + a_1 T + a_2/2 T^2 + a_3/3 T^3 + a_4/4 T^4 + a_6 $ <entropy>

The seven coefficients, $a_0$ to $a_6$, are supplied and were calculated from experimental results. This is known as the NASA 7-coefficient polynomial. There are two 'modes' that the coefficients can appear as, one set for $200K < T < 1000 K$, and another for $1000K < T < 6000K$.

== Gas Dynamics
Two main gas dynamic models are used, Isentropic one-dimensional expansion or compression, and general one-dimensional balance equation solver.
=== Isentropic Expansion/compression
This model is utilised when change of cross sectional area occurs. An analytical solution is described in previous theses, and they elaborate that due to the fact that #sym.gamma changes during the processes, these solutions cannot be used (this also means that the assumption of a calorically perfect gas is not valid). Instead, variables are found with the following method.
\ \
An iteration loop is utilised, initialising with a trial Mach number, $M_2$, and determines temperature at Node 2, $T_2$, using the energy equation:
$ h_2 + (M_2^2 a_2^2)/2 = h_1 + (M_1^2 a_1^2) / 2 $
Which is another form of the more familiar energy equation using velocity:
$ h_2 + (u_2^2)/2 = h_1 + (u_1^2) / 2 $
The temperature, $T_2$, is calculated in the inner iteration loop, which is required for the $h_2$. The pressure at Node 2, $P_2$, is then calculated from the entropy equation:
$ S^0 (T_2) - R ln P_2/P_0 = S^0 (T_1) - R ln P_1/P_0 $
Note: entropy equation is only valid for constant entropy, this means for most cass that gas composition must be constant, but the shifting equilibrium assumption can be made under the assumption of constant entropy.
\ \
Once the thermokinetic state at Node 2 is calculated, the mass flow rate is compared against that of the inlet node, Node 1. If there is a difference, the iteration loop (starting with the choosing of a new M_2) is repeated, until a convergence tolerance is met.

=== Balance Equation Solver
This model is utilised when no change of cross sectional area occurs. The model is based on the conservation of mass, momentum, and energy. The model is a one-dimensional model, and is based on the following equations:
\ \
$ #sym.rho _1 u_1 - #sym.Delta G = #sym.rho _2 u_2 $ <mass_balance>




@mass_balance can be derived from the conservation of mass, where $#sym.rho$ is the density, $u$ is the velocity, $A$ is the duct cross-sectional area, and $G$ is the mass flow rate. 
#figure(
  diagram(
  node-stroke: (thickness: 1pt, dash: "dashed",),
  node((2,0), [$c o n t r o l ()/() v o l u m e (c v)$],height: 3cm, width: 5cm, outset:0pt),
  edge((0,0), (2,0), "->", $dot(m)_1, u_1, #sym.rho _1$ ),
  edge((2,0), (4,0), "->", $dot(m)_2, u_2, #sym.rho _2$ ),
  edge((1.42,-0.50),(1.42,0.50), "<->",),
  node((1.68,0.3),$A_1 = A_2$,stroke:none)
  )
)
\
For a system where the condition of continuity is met: \
$ dot(m) _1 = dot(m) _2 $

= Blocks included in HyPro
== Inlet
The inlet model is responsible for the handling of the air that is coming into the system. This part is not applicable for the use in rocketry systems, but is included in my documentation for the sake of completeness.
\ \
The inlet utilises two types of models, variable geometry convergent-divergent (C-D) intake ramps, and variable centre body intakes.
=== C-D Ramp
Ideal intake that converts supersonic free stream into a subsonic flow isentropically. This idealistic system is hard to impliment in practice however and would form inconvenient shocks in reality. #image("supersonic_inlet_with_mobile_panel_Tudosie.png")
=== Centre body
The centre body intake differs from the C-D ramp in that rather than slowing the air at the throat of a nozzle, it is slowed using a set of shocks, which initially form at the front of the intake.
== Fan/compressor
A simple model for fans and compressors is provided in HyPro. The model takes the total pressure ratio as input, and considers compression to be isentropic.
== Mixer
== Injector

== Combustor
== Nozzle