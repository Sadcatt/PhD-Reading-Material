#set text(
  font:"Verdana"
  )
#set par(
  justify: true
  )
#set heading(
  numbering: "1."
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