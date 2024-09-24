(define-map items
    { id: uint }
    { seller: principal, price: uint, status: uint, highest-bid: uint, highest-bidder: principal, end-time: uint }) ;; 0: listed, 1: sold, 2: canceled

(define-public (list-item (id uint) (starting-price uint) (duration uint))
    (map-set items { id: id } { seller: tx-sender, price: starting-price, status: u0, highest-bid: u0, highest-bidder: tx-sender, end-time: (+ (block-height) duration) })
    (ok true)
)

;; Refactor bid validation in `bid-item` to ensure only valid bids are accepted
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


;; Refactor `end-auction` for efficient handling of sold and unsold items
(define-public (end-auction (id uint))
    (let ((item-info (map-get? items { id: id })))
        (match item-info
            item
            (if (>= (block-height) (get end-time item))
                (begin
                    ;; Transfer item to the highest bidder if there was a bid
                    (if (> (get highest-bid item) u0)
                        (begin
                            (contract-call? .token-contract transfer tx-sender (get seller item) (get highest-bid item)) ;; Transfer bid amount to the seller
                            (map-set items { id: id } { seller: (get seller item), price: (get highest-bid item), status: u1, highest-bid: u0, highest-bidder: (get highest-bidder item), end-time: u0 })
                            (ok true)
                        )
                        (begin
                            ;; If no bids, mark as sold without a transfer
                            (map-set items { id: id } { seller: (get seller item), price: (get price item), status: u2, highest-bid: u0, highest-bidder: tx-sender, end-time: u0 })
                            (ok true)
                        )
                    )
                )
                (err u3) ;; Auction is still ongoing
            )
            (err u1) ;; Item not found
        )
    )
)


;; Ensure that `buy-item` only allows purchasing of items that are available for sale
(define-public (buy-item (id uint))
    (let ((item-info (map-get? items { id: id })))
        (match item-info
            item
            (if (== (get status item) u0)
                (begin
                    (contract-call? .token-contract transfer tx-sender (get seller item) (get price item))
                    (map-set items { id: id } { seller: (get seller item), price: (get price item), status: u1, highest-bid: u0, highest-bidder: tx-sender, end-time: u0 })
                    (ok true)
                )
                (err u2) ;; Item not available for sale
            )
            (err u1) ;; Item not found
        )
    )
)
