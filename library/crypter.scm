(module crypter racket/base
	(require (except-in racket/contract any) srfi/1)
	
	;(define (encrypt data key)
	;	(define (f d k r)
	;		(let ((i (bitwise-xor d (cdr r) k)))
	;			(cons (cons i (car r)) i)
	;		)
	;	) 
	;	(list->bytes
	;		(car (fold f (cons (list) 0) (bytes->list data) (apply circular-list (bytes->list key))))
	;	)
	;)
	;(define (decrypt data key)
	;	(define (f d k r)
	;		(let ((i (bitwise-xor d (cdr r) k)))
	;			(cons (cons i (car r)) d)
	;		)
	;	)
	;	(list->bytes
	;		(car (fold f (cons (list) 0) (bytes->list data) (apply circular-list (bytes->list key))))
	;	)
	;)
	
	(define (update-key key size)
		(let ((t (+ (integer-bytes->integer (subbytes key 0 4) #f) size)) (m (expt 2 32)))
			(bytes-append (integer->integer-bytes (if (>= t m) (- t m) t) 4 #f) (subbytes key 4 8))
		)
	)
	
	(define (encrypt data key)
		(define (f d r k p)
			(if (null? d)
				r
				(let ((i (bitwise-xor (car d) p (car k))))
					(f (cdr d) (cons i r) (cdr k) i)
				)
			)
		)
		(let ((data (bytes->list data)) (key (apply circular-list (bytes->list key))))
			(list->bytes (reverse (f data (list) key 0)))
		)
	)
	
	(define (decrypt data key)
		(define (f d r k p)
			(if (null? d)
				r
				(let ((i (bitwise-xor (car d) p (car k))))
					(f (cdr d) (cons i r) (cdr k) (car d))
				)
			)
		)
		(let ((data (bytes->list data)) (key (apply circular-list (bytes->list key))))
			(list->bytes (reverse (f data (list) key 0)))
		)
	)
	
	(define (make-crypter key)
		(define encrypt-key key)
		(define decrypt-key key)
	
		(lambda (data encrypt?)
			(if encrypt?
				(let ((data (encrypt data encrypt-key)))
					(set! encrypt-key (update-key encrypt-key (bytes-length data)))
					data
				)
				(let ((data (decrypt data decrypt-key)))
					(set! decrypt-key (update-key decrypt-key (bytes-length data)))
					data
				)
			)
		)
	)
	
	(define (length-is-8? data)
		(= (bytes-length data) 8)
	)
	
	(provide (contract-out
		(make-crypter ((and/c bytes? length-is-8?) . -> . procedure?))
	))
)
