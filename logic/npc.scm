(module logic racket/base
	(require
		(rename-in racket/contract (any all/c))
		srfi/1
		"../library/structure.scm"
		"main.scm"
		"creature.scm"
	)
	(provide (contract-out
		(npc? (box? . -> . boolean?))
		(create-npc (list? . -> . box?))
		(update-npc! (box? list? . -> . void?))
	))
	
	(define (npc? object)
		(if (member 'npc (@: object 'type)) #t #f)
	)
	
	(define (create-npc struct)
		(let ((creature (create-creature struct)))
			(let ((type (cons 'npc (@: creature 'type))))
				(box (append (alist-delete 'type creature) (list
					(cons 'type type)
					
					(cons 'show-name? (@: struct 'show-name?))
					(cons 'attackable? (@: struct 'attackable?))
					(cons 'spoiled? (@: struct 'spoiled?))
					(cons 'summoned? (@: struct 'summoned?))
				)))
			)
		)
	)
	
	(define (update-npc! npc struct)
		(set-box! npc
			(let ((npc (update-creature (unbox npc) struct)))
				(struct-transfer npc struct
					'show-name?
					'attackable?
					'spoiled?
					'summoned?
				)
			)
		)
	)
)