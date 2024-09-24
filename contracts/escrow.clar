(define-map escrow-balances
    { buyer: principal, seller: principal, item-id: uint }
    { amount: uint })

(define-public (hold-funds (amount uint) (buyer principal) (seller principal) (item-id uint))
    (map-set escrow-balances { buyer: buyer, seller: seller, item-id: item-id } { amount: amount })
    (contract-call? .token-contract transfer buyer tx-sender amount)
)


(define-public (release-funds (buyer principal) (seller principal) (item-id uint))
    (let ((escrow-info (map-get? escrow-balances { buyer: buyer, seller: seller, item-id: item-id })))
        (match escrow-info
            info
            (begin
                (contract-call? .token-contract transfer tx-sender seller (get amount info))
                (map-delete escrow-balances { buyer: buyer, seller: seller, item-id: item-id })
                (ok true)
            )
            (err u1) ;; Escrow not found
        )
    )
)