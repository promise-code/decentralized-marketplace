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
            (if (is-eq (get status item) u0)
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
            (if (is-eq (get status item) u0)
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

(define-map reviews
    { seller: principal, reviewer: principal }
    { rating: uint, comment: (optional string) })

(define-public (leave-review (seller principal) (rating uint) (comment (optional string)))
    (if (and (>= rating u1) (<= rating u5)) ;; Assuming rating is between 1 and 5
        (begin
            (map-set reviews { seller: seller, reviewer: tx-sender } { rating: rating, comment: comment })
            (ok true)
        )
        (err u1) ;; Invalid rating
    )
)

(define-read-only (get-review (seller principal))
    (ok (map-get? reviews { seller: seller, reviewer: tx-sender })))


(define-map item-categories
    { id: uint }
    { category: string })

(define-public (set-item-category (id uint) (category string))
    (let ((item-info (map-get? items { id: id })))
        (match item-info
            item
            (if (is-eq (get status item) u0)
                (begin
                    (map-set item-categories { id: id } { category: category })
                    (ok true)
                )
                (err u1) ;; Item is not available for categorization
            )
            (err u2) ;; Item not found
        )
    )
)

(define-read-only (get-items-by-category (category string))
    (ok (filter (fun (item) (is-eq (get category (map-get? item-categories { id: (get id item) })) category)) (map-values items))))
