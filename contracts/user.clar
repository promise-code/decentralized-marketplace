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


(define-map access-control
    { user: principal }
    { has-access: bool })

(define-public (check-access (user principal))
    (let ((current-reputation (map-get? user-reputation { user: user })))
        (if (and (is-ok current-reputation) (>= (get rating (unwrap current-reputation)) u4)) ;; Assuming 4 is the threshold for access
            (begin
                (map-set access-control { user: user } { has-access: true })
                (ok true)
            )
            (begin
                (map-set access-control { user: user } { has-access: false })
                (ok false)
            )
        )
    )
)
