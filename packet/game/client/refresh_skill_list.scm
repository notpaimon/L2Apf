(module system racket/base
	(provide game-client-packet/refresh-skill-list)
	(require "../../packet.scm")
	
	(define (game-client-packet/refresh-skill-list)
		(let ((s (open-output-bytes)))
			(begin
				(write-byte #x50 s)
				(get-output-bytes s)
			)
		)
	)
)