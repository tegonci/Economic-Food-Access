;globals  TO DO uncertainty as global or local

; ************************************************
; **********     Agent definition     ************
; ************************************************

; Create  breeds of neighbourhood
breed [ districts district ]  ; agentset of patches7neighbourhood where store agents and consumer agents are located


; Create 3 breeds of store agent
breed [ supermarkets supermarket ]
breed [ convenience-stores convenience-store ]
breed [ proximity-stores proximity-store ]


;Create different types of consumer agents
breed [consumer-as consumer-a]
breed [consumer-bs consumer-b]
breed [consumer-cs consumer-c]

; Create supermarket variables
supermarkets-own [
  attractiveness ; Records the stores attractivess score for price index and food quality
  customers ; Records the who number of each consumer agent that visits the store
  online-shopping ; Records the number of online purchase
  moving ;if number of constumer is low and no satisfaction, move to another district
]

; Create convenience-store variables
convenience-stores-own [
  attractiveness ; Records the stores attractivess score for price index and food quality
  customers ; Records the who number of each consumer agent that visits the store
  online-shopping ; Records the number of online purchase
  moving ;if number of constumer is low, move to another district
]

; Create proximity-store variables
proximity-stores-own [
  attractiveness ; Records the stores attractivess score for price index and food quality
  customers ; Records the who number of each consumer agent that visits the store
  online-shopping ; Records the number of online purchase
  moving ;if number of constumer is low, move to another district
]

; Create consumer variables
consumer-as-own [
  home-location ; Stores the home location of consumer
  destination ; Keeps track of the consumers current destination
  probability ; utility function including all factors that keeps track of the consumers current probability of purchasing healthy food
  distance-travelled ; Keeps track of the distance travelled by the consumer
  health ; keep track record of health status
  moving ;if health is low, move to another district where you can afford to buy healthy food (listening to your network)but it not n italin caracteristic may be only shops move
]

consumer-bs-own [
  home-location
  destination
  probability
  visits
  distance-travelled
  moving 
]

consumer-cs-own [
  home-location
  destination
  probability
  visits
  distance-travelled
  moving
]

; Create patches variables
districts-own [
  area-type ; Records the geo-demographic type of the patch
  total-health ; sumup all health status of current agents
  total-purchase ; n. of times a consumer hit local shops, to serve as reference for shops that want to move
  fai ; food accessibility index
]

; ************************************************
; ************     Go procedures      ************
; ************************************************

; Procedure called every time the model iterates