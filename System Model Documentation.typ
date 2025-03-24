#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#set text(font: "Calibri")
/*#set text(
  font:"Verdana"
  )
  */
#set par(
  justify: true
  )
  #set page(
    margin:(top: 1.5cm, bottom: 1.5cm, left: 1.5cm, right: 1.5cm)
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
#set text(size:11pt)

#show heading: it => pad(left: 1em * it.level, it)

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

$ #sym.rho _1 u_1 - #sym.Delta G = #sym.rho _2 u_2 $ <mass_balance>
$ P_1 + #sym.rho _1 u^2 _1 -#sym.Delta I = P_2 + #sym.rho _2 u^2 _2 $ <momentum_balance>
$ G_1/G_2 (h_1 + u_1^2/2 - #sym.Delta H) = h_2 + u^2_2/2 $

Balance equation solver has different sub-forms depending on the type of block that is being modelled. The form described above is the general form.


==== Mass Balance
@mass_balance can be derived from the conservation of mass, where $#sym.rho$ is the density, $u$ is the velocity, $A$ is the duct cross-sectional area, and $G$ is the mass flow rate. 
#figure(
  diagram(
  node-stroke: (thickness: 1pt, dash: "dashed",),
  node((2,0), [$"control volume(cv)"$],height: 3cm, width: 5cm, outset:0pt),
  edge((0,0), (2,0), "->", $ #sym.Delta G_1, u_1, #sym.rho _1$ ),
  edge((2,0), (4,0), "->", $#sym.Delta G_2, u_2, #sym.rho _2$ ),
  edge((1.42,-0.50),(1.42,0.50), "<->",),
  node((1.68,0.3),$A_1 = A_2$,stroke:none)
  )
)

For a system where the condition of continuity is met: \
$ #sym.Delta G_1 = #sym.Delta G_2 $ <continuity>

However, in the case where fluid is injected into the flow between nodes 1 and 2, like in the case of the injector block, mass flux entering the block at node 1 is unequal to mass flux exiting the block at node 2 and hence continuity condition is not met. Ammended @discontinuity is shown below:
$ #sym.Delta G_1 + #sym.Delta G_"additional" = #sym.Delta G_2  $ <discontinuity>
Mass flux through a cross section is determined as follows:
$ #sym.Delta G = #sym.rho u A $ <mass_flux>
Subsituting in @mass_flux into @discontinuity, we can cancel the area terms, due to constant cross sectional area, and therefore derive @mass_balance.

==== Momentum Balance
@momentum_balance can be derived from the conservation of momentum, where $P$ is the pressure, $I$ is the specific kinetic energy, and $H$ is the specific enthalpy.

==== Energy Balance


= Blocks included in HyPro
== Irrelevant Section But Documented for Completeness
=== Inlet
The inlet model is responsible for the handling of the air that is coming into the system. This part is not applicable for the use in rocketry systems, but is included in my documentation for the sake of completeness.
\ \
The inlet utilises two types of models, variable geometry convergent-divergent (C-D) intake ramps, and variable centre body intakes.

==== C-D Ramp
Ideal intake that converts supersonic free stream into a subsonic flow isentropically. This idealistic system is hard to impliment in practice however and would form inconvenient shocks in reality. #image("supersonic_inlet_with_mobile_panel_Tudosie.png")

==== Centre body
The centre body intake differs from the C-D ramp in that rather than slowing the air at the throat of a nozzle, it is slowed using a set of shocks, which initially form at the front of the intake.

=== Fan/compressor
A simple model for fans and compressors is provided in HyPro. The model takes the total pressure ratio as input, and considers compression to be isentropic.

=== Mixer
The mixer model enables two flows to be combined. This model was originally designed for use in combined cycle engines where there is a primary and secondary flow which needed to be merged, this however is not applicable for use in rocket engines and also shall not be further covered in my documentation.

== Importanter Section

=== Injector
Injection is considered separately from other blocks like combustors and mixers in HyPro in order to support any kind of flowpath. There are a number of scenarios that require different factors to be accounted for. These include injection in an airbreating enginer flow, as well as fuel and oxidiser flow injected into a rocket combustion chamber. For both of these models, if a module downstream chokes, the mass flow rate is reduced

==== Airbreathing Engine Flow
Airbreating fuel injection has two types of modelling, these include a simple pressure change, as well as a custom balance equation solver which applies to the flow at the injector.

===== Simple Assumption
The simpler model assumes that pressure is increased at node 2 of the model following @injector_air_simple:
$ P_2 = P_1 / (1-X_"fuel") $ <injector_air_simple>
Where $X_"fuel"$ is the molar fraction of fuel in the flow.

===== More Complex Assumption
The more complex model is based on the balance equation solver, which is described in the gas dynamics section. This model assumes that the momentum of the injected fuel is negligable compared to the main flow. The user must also set an equivalence ratio $#sym.phi$, which is the ratio of the actual fuel to oxidiser ratio to the stoichiometric ratio, as well as fuel temperature, $T_"inj"$.
$ #sym.Delta G = -(#sym.phi #sym.Phi)W_f/W_1 (X_"ox") #sym.rho _1 u_1 $
$ #sym.Delta I = 0 $
$ #sym.Delta H = #sym.Delta G h_f $

==== Rocket Motor Flow
Rocket motor flow is the other type of scenario modelled in HyPro, where fuel is injected into the combustion chamber. There are two models included in the HyPro code base which deal with this injection, however they each find different variables of the same set of equiations:
$ P_2 = #sym.rho _2 R T_2 $
$ "where" #sym.rho _2 = dot(m)/(M_2 a_2 A_2) $
The alternative module, $"InjectionPlatePressure"$ is the alternative version of the module which instead of determining updated pressure, Mach number at node 2, $M_2$ is determined. For the case of the rocket motor flow, when $M_"throat" = 1$, flow upstream is choked, and mass flow rate is limited / reduced. Mass flow rate, $dot(m)$, accounts for the flow of both fuel and oxidiser. 

=== Combustor
The combustor has been routinely described by the previous guys as being a "ballache". It is difficult to model due to "the complexity fo the phenomena that occur within them.", and easy assuptions we rely on like ideal gas cannot be employed due to the high temperature present. The effects of mixing as well as finite rate chemical reactions require accounting.
\ All options for modelling propulsion in HyPro utilise a large number of assumptions in order to model combustion. The original method assumed complete combustion of a global reaction mechanism, and only accounted for incomplete combustion in the form of a blanket efficiency factor applied to change in downstream enthalpy, shown in @downstream_enthalpy:
$ #sym.Delta H = (1 - #sym.eta)[h(T_"ref" , X_1)-h(T_"ref" , X_2)]G_1 $ <downstream_enthalpy>
This method is a simple Nat-5 style chemistry equation, which finds the overall enthalpy of combustion using the difference of specific heats of formation for products and reactants at a reference temperature of $300 K$, multiplied by the mass at the node to find enthalpy in Joules, then ammended using the efficiency factor. 

=== Nozzle
#pagebreak()
= System Model Diagram
== Rocket Propulsion
Using the blocks listed above, rocket propulsion is modelled in @liq_biprop using the following structure:
#import fletcher.shapes: diamond

#figure(
  diagram(
    node-stroke :1pt,
    cell-size: 10mm,
    node-fill: gray.lighten(60%),
    node((0,0), [Start], corner-radius: 2pt),
    edge("-|>"),
    node((1,0), [Injector],extrude: (0, 1)),
    edge("-|>"),
    node((2,0),[Combustor],extrude: (0, 1)),
    edge("-|>"),
    node((3,0),[Convergent Nozzle],extrude: (0, 1)),
    edge("-|>"),
    node((4,0),[Divergent Nozzle],extrude: (0, 1)),
    edge((3,0),(1,0),`Choking feedback`,"--|>",bend:-20deg),
    edge((1,1),(1,0),`Throttle`,"--|>"),
    edge((4,1),(4,0),`Thrust`,"--|>")
  ),
  caption:[Structure of Simple Bi-Propellant Liquid Rocket Propulsion Model in HyPro]
)<liq_biprop>

Choking feedback refers to the phenomenon when the velocity at the throat reaching Mach 1, meaning mass flow rate is capped according to @throat_mass_flow, having the knock-on effect that upstream flow velocty also cannot increase, hence limiting the mass flow rate. In the case where more mass is injected than can flow through the throat, chamber pressure and temperature would increase to the point of rupturing. Because of this, this metric is used to assist throttling the injector.
$ dot(m)_"throat-max" = (A P_"throat")/sqrt(T_"throat") sqrt(#sym.gamma/R) ((#sym.gamma -1)/2)^(-(#sym.gamma + 1)/(2(#sym.gamma - 1))) $<throat_mass_flow>
