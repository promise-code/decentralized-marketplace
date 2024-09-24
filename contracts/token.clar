(define-map items
    { id: uint }
    { seller: principal, price: uint, status: uint, highest-bid: uint, highest-bidder: principal, end-time: uint }) ;; 0: listed, 1: sold, 2: canceled

(define-public (list-item (id uint) (starting-price uint) (duration uint))
    (map-set items { id: id } { seller: tx-sender, price: starting-price, status: u0, highest-bid: u0, highest-bidder: tx-sender, end-time: (+ (block-height) duration) })
    (ok true)
)

(define-public (bid-item (id uint) (amount uint))
    (let ((item-info (map-get? items { id: id })))
        (match item-info
            item
            (if (and (== (get status item) u0) (> amount (get highest-bid item)) (>= (get end-time item) (block-height)))
                (begin
                    ;; Refund the previous highest bidder
                    (if (not (== (get highest-bid item) u0))
                        (contract-call? .token-contract transfer (get highest-bidder item) (tx-sender) (get highest-bid item))
                    )
                    ;; Update the highest bid and bidder
                    (map-set items { id: id } { seller: (get seller item), price: (get price item), status: u0, highest-bid: amount, highest-bidder: tx-sender, end-time: (get end-time item) })
                    (ok true)
                )
                (err u2) ;; Invalid bid
            )
            (err u1) ;; Item not found
        )
    )
)
