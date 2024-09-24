(define-map items
    { id: uint }
    { seller: principal, price: uint, status: uint }) ;; 0: listed, 1: sold, 2: canceled

(define-public (list-item (id uint) (price uint))
    (map-set items { id: id } { seller: tx-sender, price: price, status: u0 })
    (ok true)
)

(define-public (buy-item (id uint))
    (let ((item-info (map-get? items { id: id })))
        (match item-info
            item
            (if (== (get status item) u0)
                (begin
                    (contract-call? .token-contract transfer tx-sender (get seller item) (get price item))
                    (map-set items { id: id } { seller: (get seller item), price: (get price item), status: u1 })
                    (ok true)
                )
                (err u2) ;; Item not available for sale
            )
            (err u1) ;; Item not found
        )
    )
)


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