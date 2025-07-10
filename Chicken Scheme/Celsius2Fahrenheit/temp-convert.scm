;; Temperature converter in Chicken Scheme
;; Converts between Celsius and Fahrenheit

(define (menu)
  (display "Temperature Converter\n")
  (display "1. Celsius to Fahrenheit\n")
  (display "2. Fahrenheit to Celsius\n")
  (display "Choose an option (1 or 2): ")
  (flush-output))

(define (c->f c)
  (+ (* 1.8 c) 32))

(define (f->c f)
  (/ (- f 32) 1.8))

(define (read-number)
  (string->number (read-line)))

(define (main)
  (menu)
  (let ((choice (read-line)))
    (cond
      ((string=? choice "1")
       (display "Enter Celsius: ") (flush-output)
       (let ((c (read-number)))
         (printf "~a °C = ~a °F\n" c (c->f c))))
      ((string=? choice "2")
       (display "Enter Fahrenheit: ") (flush-output)
       (let ((f (read-number)))
         (printf "~a °F = ~a °C\n" f (f->c f))))
      (else
       (display "Invalid option.\n")))))

(main)
