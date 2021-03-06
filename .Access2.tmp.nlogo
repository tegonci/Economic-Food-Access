globals [
  b0      ; constant
 ; b1      ; edu
 ; b2      ; age
  b3      ; env concerns
  b4      ; health concerns
  b5      ; WTP (or price sensitivity?)
  b6      ; beta nutritional awareness
  b7      ; beta socio economic status index
  ;b8      ; willingness to move for shopping
]


; ************************************************
; **********     Agent definition     ************
; ************************************************

; Create  breeds of neighbourhood
breed [ districts district ]  ; agentset of patches/neighbourhood where store agents and consumer agents are located

; Create 3 breeds of store agent
breed [ supermarkets supermarket ]
breed [ convenience-stores convenience-store ]
breed [ proximity-stores proximity-store ]

; Create consumer agents
breed [consumers consumer]

; create policy maker
; let or  bread to create foodcity planner to see


; Create patches variables
districts-own [
  n.citizens              ; count the number of citizen per district at each 365 day 1 year period
  total-health            ; sumup all health status of current agents
  d.healthy.choices       ; sumup all positive helathy choice in one district
  total-consumers         ; n. of times a consumer hit local shops, to serve as reference for shops that want to move
  fai                     ; food accessibility index
  sci                     ; socio economical status index
  pri                     ; price index
]

; Create consumer variables
consumers-own [
  ;age
  ;edu                     ; level of education
  env                      ; stores the level of env concerns
  health.con               ; stores the level of health concerns
  wtp                      ; willingness to pay or price sensitivity?
  nutr.awareness           ; stores the level of awareness ( 0=unaware, 0.5 =medium  1=aware) info about healthy food)
  sc.s.index               ; indice di status socio economico
  ;accessibility           ; Keeps track of max distance a counsumer is willing to travel
  location                 ; stores the home location of consumer
  purchase-prb             ; individual likelihood of purchasing healthy food, utility function discrete choice, should be done weekly (every 7 ticks)
  Total.health             ; keep track record of health status, subject to the purchase of healthy food (healthy diet), updated weekly
  need-to-shop             ; activity updated weekly
  healthy.choice           ; positive results of shop behaviours
  ;healthy.choice2         ; negative results of shop behaviours
  destination              ; best retailer
  newlocation              ; if no best retailer options, relocate to a new district with better fai
  n.healthy.choices       ;total of choices
  ;n.healthy.choices2

]

supermarkets-own [
  localization              ; position in district
  food-quality              ; assume the healthyness of food sold in the shop as a basket of products
  price-index               ; assign a price index corresponding to the one of the district
  customers                 ; Records the who number of each consumer agent that visits the store
  attractiveness            ; convenience, ratio food quality/price index
]
convenience-stores-own [
  localization
  food-quality
  price-index
  customers
  attractiveness
]
proximity-stores-own [
  localization
  food-quality
  price-index
  customers
  attractiveness
]
; ************************************************
; ************    Setup procedures    ************
; ************************************************

; Procedure to set up the model
to setup
  clear-all
  reset-ticks
  purchse-prb-init-parameters
  setup-patches
  setup-districts
  setup-supermarkets
  setup-convenience-stores
  setup-proximity-stores
  setup-consumers

end

 to setup-patches

  ask patches [
    set pcolor white
  ]
end

; Procedure to configure districts
to setup-districts ;

  create-districts 6
  [ set shape "square"
    set size 6
    setxy random-xcor random-ycor

  ]

  ask district 0
  [ set color yellow
    set sci 0.99
    set pri 0.99
    set fai 0.36
    setxy 10 10
    set d.healthy.choices 0
  ]

  ask district 1
  [ set color lime
    set sci 0.51
    set pri 0.99
    set fai 0.74
    setxy 2 11
    set d.healthy.choices 0
  ]

  ask district 2
  [ set color orange
    set sci 0.64
    set pri 0.57
    set fai 0.46
    setxy 17 3
    set d.healthy.choices 0
  ]

  ask district 3
  [ set color blue
    set sci 0.24
    set pri 0.21
    set fai 0.74
    setxy 17 9
    set d.healthy.choices 0
  ]

  ask district 4
  [ set color pink
    set sci 0.38
    set pri 0.35
    set fai 0.55
    setxy 12 15
    set d.healthy.choices 0
  ]

  ask district 5
  [ set color brown
    set sci 0.77
    set pri 0.35
    set fai 0.25
    setxy 4 5
    set d.healthy.choices 0
  ]


end

; Procedures to set up retailers agents
to setup-supermarkets
  create-supermarkets number-of-supermarkets [
      set shape "square" ; Set the shape of the supermarket store agent to square
      set color red ; Set the colour of the supermarket store agent to red
      set price-index   random-float 1
      set food-quality  random-float 1
      set attractiveness food-quality / price-index
      set customers 0
      set localization one-of districts with [ color = brown or color = blue]
      move-to localization ;if not any? supermarkets-here   ;how to make just one supermarket on a patch?
      set customers 0
  ]
end

to setup-convenience-stores
  create-convenience-stores number-of-convenience-stores [
      set shape "circle 2" ; Set the shape of the supermarket store agent to square
      set color black ; Set the colour of the supermarket store agent to red
      set price-index random-float 1
      set food-quality random-float 1
      set attractiveness food-quality / price-index
      set customers 0
      set customers 0
      set localization one-of districts with [ color = lime or color = blue or color = orange or color = yellow or color = pink]
       move-to localization;ifelse not any? convenience-stores-here [move-to localization][
      ;move-to one-of patches with[not any? convenience-stores-here]
    ;]
  ]
end

to setup-proximity-stores
  create-proximity-stores number-of-proximity-stores [
      set shape "star" ; Set the shape of the supermarket store agent to square
      set color cyan ; Set the colour of the supermarket store agent to red
      set price-index random-float 1
      set food-quality random-float 1
      set attractiveness food-quality / price-index
      set customers 0
      set localization one-of districts with [ color = lime or color = blue or color = orange or color = yellow or color = pink]
       move-to localization;ifelse not any? proximity-stores-here [move-to localization][
      ;move-to one-of patches with[not any? proximity-stores-here]
    ;]
    ]
end

; procedures to set up consumers
to setup-consumers

  create-consumers number-of-consumers [
    set shape "person" ; Set the shape of the supermarket store agent to square
    set color 125 ; Set the colour of the supermarket store agent to red
    ;setxy random-xcor random-ycor
    set need-to-shop 0
    set healthy.choice 1
    ;set healthy.choice2 1
    set purchase-prb 0
    ;set age random-float 65
    ;set edu random-float 1.0
    set env random-float 1.0
    set health.con random-float 1.0
    set nutr.awareness random-float 1.0
    set sc.s.index random-float 1.0    ;verify how between values can be assigned
    set destination 0
    set Total.health 10
    set n.healthy.choices  1
    ;set n.healthy.choices2 1
  ]

  ask consumers [
    if sc.s.index <= 0.24
    [set location district 3
     set wtp [fai] of district 3
     move-to location
     ]

    if sc.s.index > 0.24 and sc.s.index <= 0.38
    [set location district 4
     set wtp [fai] of district 4
     move-to location]

    if sc.s.index > 0.38 and sc.s.index <= 0.51
    [set location district 5
     set wtp [fai] of district 5
     move-to location]

    if sc.s.index > 0.51 and sc.s.index <= 0.64
    [set location district 2
     set wtp [fai] of district 2
     move-to location]

    if sc.s.index > 0.64 and sc.s.index <= 0.77
    [set location district 1
     set wtp [fai] of district 1
     move-to location]

    if sc.s.index > 0.77 and sc.s.index <= 1
    [set location district 0
     set wtp [fai] of district 0
     move-to location]
  ]

end


; ************************************************
; ************     Go procedures      ************
; ************************************************

; Procedure called every time the model iterates


; TO DO with a real survay or data collected on Milano
to purchse-prb-init-parameters ;Initialize parametersof the DM process, initial parameters are taken from a real survay [BSA survey (2016)] of another case but they are arbitrary
  set b0  0        ; constant but for the moment we don't have hte full analysis so it is kept to zero
  ;set b1  .655    ; edu
  ;set b2  .016    ; age
  set b3  0.287    ; env concerns
  set b4  0.623    ; health concerns
  set b5  0.101    ; perceived living cost used as a proxy for price sensitivity
  set b6  0.101    ; beta nutritional awareness
  set b7  0.100    ; beta socio economic status index
; setb8
end

To go
  if ticks >= 365 [stop]

  ask consumers [
    set need-to-shop need-to-shop + random-float 1
    ifelse need-to-shop > 0.4 [
      shop]
    [set need-to-shop 0]
  ] ;prb it is never 0

  ask consumers[
    consumers-stat
  ]

  ask districts [
   district-stat
   update-labels
  ]

  tick
end

to shop ; is not working
  ; at the end this procedure I should find the purchase probability of healthy food in population if they find the good conditionin the stores around
  ; I would like to plot the probbaility of healthy.choice of population, and the actual purchase ideally explore it against fai (food accessibility index)
  ask consumers [
    set purchase-prb est-prb
    ;show purchase-prb
    ifelse  purchase-prb > [wtp] of myself
    [set healthy.choice 1]
    [set healthy.choice 0]

  ]
   ; TO DO update health and implement supermarket choise and relocate after tot times you have not satisfied your choices

end


;; probability to shop a meal based on healthy meals using the inverse log reg function at any time during the simulation
to-report est-prb
 let y (b0 + (b3 * env) + (b4 * health.con) + (b5 * wtp) + (b6 * nutr.awareness) + (b7 * sc.s.index) )
 ; show (word  who " env : " env ", health.con: " health.con ", wtp : " wtp ", nutr.awareness : " nutr.awareness ", sc.s.index : " sc.s.index ", result y : " y)
 let above e ^ y
 let below (1 + e ^ y)
 report (1 - (above / below)) ;* uncertainty obviously need to be around a standard deviation etc to check
end


;To relocate -consumer, if agents not satisfied they move to the closer district with better fai
;end

;To relocate -shops, if agents not satisfied of hte number of client they should move to the closer  district with better overall number of client (sum of all client in teh shop in the districts)
;end

 to district-stat ; district proc.
   set n.citizens count consumers-here
   set d.healthy.choices sum [healthy.choice] of consumers-here
  ;show d.healthy.choices
end

to update-labels
  ask districts  [
    set label (word fai)
    set label-color black]

end

to consumers-stat
  set n.healthy.choices sum [healthy.choice] of consumers
  show n.healthy.choices
end

@#$#@#$#@
GRAPHICS-WINDOW
307
22
805
521
-1
-1
23.333333333333332
1
10
1
1
1
0
1
1
1
0
20
0
20
0
0
1
ticks
30.0

BUTTON
55
74
121
107
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
132
72
195
105
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
38
147
251
180
number-of-supermarkets
number-of-supermarkets
0
7
2.0
1
1
NIL
HORIZONTAL

SLIDER
39
193
271
226
number-of-convenience-stores
number-of-convenience-stores
0
20
14.0
1
1
NIL
HORIZONTAL

SLIDER
38
248
272
281
number-of-proximity-stores
number-of-proximity-stores
0
20
14.0
1
1
NIL
HORIZONTAL

SLIDER
37
304
234
337
number-of-consumers
number-of-consumers
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
38
359
210
392
uncertainty
uncertainty
0
1
1.0
0.1
1
NIL
HORIZONTAL

PLOT
910
59
1110
209
Healthy choice of consumers
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"H1" 1.0 0 -16777216 true "" "plot mean [n.healthy.choices] of consumers"

PLOT
925
254
1125
404
Healthy Choices in each district
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"d0" 1.0 0 -16777216 true "" "plot [d.healthy.choices] of district 0"
"d1" 1.0 0 -7500403 true "" "plot [d.healthy.choices] of district 1"
"d2" 1.0 0 -2674135 true "" "plot [d.healthy.choices] of district 2"
"d3" 1.0 0 -955883 true "" "plot [d.healthy.choices] of district 3"
"d4" 1.0 0 -6459832 true "" "plot [d.healthy.choices] of district 4"
"d5" 1.0 0 -1184463 true "" "plot [d.healthy.choices] of district 5"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
