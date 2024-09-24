(define-map items
    { id: uint }
    { seller: principal, price: uint, status: uint, highest-bid: uint, highest-bidder: principal, end-time: uint }) ;; 0: listed, 1: sold, 2: canceled

(define-public (list-item (id uint) (starting-price uint) (duration uint))
    (map-set items { id: id } { seller: tx-sender, price: starting-price, status: u0, highest-bid: u0, highest-bidder: tx-sender, end-time: (+ (block-height) duration) })
    (ok true)
)
