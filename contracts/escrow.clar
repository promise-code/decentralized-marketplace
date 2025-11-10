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

(define-map arbitrators
    { item-id: uint }
    { arbitrator: principal })

(define-public (assign-arbitrator (item-id uint) (arbitrator principal))
    (begin
        (map-set arbitrators { item-id: item-id } { arbitrator: arbitrator })
        (ok true)
    )
)


(define-public (arbitrate-dispute (buyer principal) (seller principal) (item-id uint) (decision uint))
    ;; decision: 0 for buyer, 1 for seller
    (let ((dispute-info (map-get? disputes { buyer: buyer, seller: seller, item-id: item-id })))
        (match dispute-info
            info
            (if (== (get status info) u1)
                (begin
                    (if (== decision u0) ;; Buyer wins
                        (begin
                            (contract-call? .token-contract transfer tx-sender buyer (get amount (map-get? escrow-balances { buyer: buyer, seller: seller, item-id: item-id })))
                        )
                        (begin
                            (contract-call? .token-contract transfer tx-sender seller (get amount (map-get? escrow-balances { buyer: buyer, seller: seller, item-id: item-id })))
                        )
                    )
                    (map-set disputes { buyer: buyer, seller: seller, item-id: item-id } { status: u2, resolution: "Arbitrated" })
                    (ok true)
                )
                (err u2) ;; No active dispute
            )
            (err u3) ;; Dispute not found
        )
    )
)