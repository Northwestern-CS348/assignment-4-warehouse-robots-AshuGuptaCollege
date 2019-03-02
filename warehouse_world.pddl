(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

    (:action robotMove
      :parameters (?loc1 - location ?loc2 - location ?r - robot)
      :precondition (and (at ?r ?loc1) (no-robot ?loc2) (connected ?loc1 ?loc2))
      :effect (and (not (no-robot ?loc2)) (not (at ?r ?loc1)) (at ?r ?loc2) (no-robot ?loc1))
    )

    (:action robotMoveWithPallette
      :parameters (?loc1 - location ?loc2 - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?loc1) (at ?p ?loc1) (no-robot ?loc2) (no-pallette ?loc2) (connected ?loc1 ?loc2))
      :effect (and (not (at ?r ?loc1)) (not (no-robot ?loc2)) (not (at ?p ?loc1)) (not (no-pallette ?loc2)) (has ?r ?p) (at ?r ?loc2) (at ?p ?loc2) (no-robot ?loc1) (no-pallette ?loc1))
    )

    (:action moveItemFromPalletteToShipment
      :parameters (?s - shipment ?loc1 - location ?sa - saleitem ?p - pallette ?o - order)
      :precondition (and (contains ?p ?sa) (not (complete ?s)) (started ?s) (packing-at ?s ?loc1) (not (available ?loc1)) (ships ?s ?o) (at ?p ?loc1) (packing-location ?loc1) (orders ?o ?sa))
      :effect (and (includes ?s ?sa) (not (contains ?p ?sa)))
    )

    (:action completeShipment
      :parameters (?s - shipment ?o - order ?loc1 - location)
      :precondition (and (packing-at ?s ?loc1) (ships ?s ?o) (not (available ?loc1)) (not (complete ?s)) (started ?s) (packing-location ?loc1))
      :effect (and (complete ?s) (available ?loc1))
    )

)
