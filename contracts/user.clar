(define-map user-reputation
    { user: principal }
    { rating: int, reviews-count: uint })

(define-public (leave-review (user principal) (rating int))
    (let ((current-reputation (map-get? user-reputation { user: user })))
        (match current-reputation
            rep
            (begin
                (let ((new-reviews-count (+ 1 (get reviews-count rep)))
                      (new-rating (/ (+ (get rating rep) rating) new-reviews-count)))
                    (map-set user-reputation { user: user } { rating: new-rating, reviews-count: new-reviews-count })
                    (ok true)
                )
            )
            (map-set user-reputation { user: user } { rating: rating, reviews-count: u1 })
        )
    )
)
