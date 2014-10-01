; Racket Abstraction Layer
(module ral racket/base
	(require racket/contract)
	(provide (contract-out
		(bytes->string/utf-16 (bytes? . -> . string?))
		(bytes->string/utf-16le (bytes? . -> . string?))
		(bytes->string/utf-16ge (bytes? . -> . string?))
		(string->bytes/utf-16 (string? . -> . bytes?))
		(string->bytes/utf-16le (string? . -> . bytes?))
		(string->bytes/utf-16ge (string? . -> . bytes?))
	))

	(define (convert data from to)
		(let ((e (bytes-open-converter from to)))
			(let-values (((u n r) (bytes-convert e data)))
				(begin
					(bytes-close-converter e)
					(if (equal? r 'complete) u #f)
				)
			)
		)
	)

	(define (bytes->string/utf-16 data)
		(let ((data (convert data "UTF-16" "")))
			(if data (bytes->string/locale data) #f)
		)
	)
	(define (string->bytes/utf-16 s)
		(let ((data (string->bytes/locale s)))
			(convert data "" "UTF-16")
		)
	)

	(define (bytes->string/utf-16le data)
		(let ((data (convert data "UTF-16LE" "")))
			(if data (bytes->string/locale data) #f)
		)
	)
	(define (string->bytes/utf-16le s)
		(let ((data (string->bytes/locale s)))
			(convert data "" "UTF-16LE")
		)
	)

	(define (bytes->string/utf-16ge data)
		(let ((data (convert data "UTF-16GE" "")))
			(if data (bytes->string/locale data) #f)
		)
	)
	(define (string->bytes/utf-16ge s)
		(let ((data (string->bytes/locale s)))
			(convert data "" "UTF-16GE")
		)
	)
)