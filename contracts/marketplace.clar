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
