(define-map escrow-balances
    { buyer: principal, seller: principal, item-id: uint }
    { amount: uint })

(define-public (hold-funds (amount uint) (buyer principal) (seller principal) (item-id uint))
    (map-set escrow-balances { buyer: buyer, seller: seller, item-id: item-id } { amount: amount })
    (contract-call? .token-contract transfer buyer tx-sender amount)
)


