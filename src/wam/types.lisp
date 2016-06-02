(in-package #:bones.wam)

(deftype cell ()
  `(unsigned-byte ,+cell-width+))

(deftype cell-tag ()
  `(unsigned-byte ,+cell-tag-width+))

(deftype cell-value ()
  `(unsigned-byte ,+cell-value-width+))


(deftype store-index ()
  `(integer 0 ,(1- +store-limit+)))

(deftype heap-index ()
  `(integer ,+heap-start+ ,(1- +store-limit+)))

(deftype stack-index ()
  `(integer ,+stack-start+ ,(1- +stack-end+)))

(deftype trail-index ()
  `(integer 0 ,(1- +trail-limit+)))

(deftype register-index ()
  `(integer 0 ,(1- +register-count+)))

(deftype functor-index ()
  `(integer 0 ,(1- +functor-limit+)))


(deftype arity ()
  `(integer 0 ,+maximum-arity+))

(deftype functor ()
  '(cons symbol arity))


(deftype code-word ()
  `(unsigned-byte ,+code-word-size+))

(deftype code-index ()
  ;; either an address or the sentinel
  `(integer 0 ,(1- +code-limit+)))


(deftype opcode ()
  '(integer 0 32))


(deftype stack-frame-size ()
  `(integer 3 ,+stack-frame-size-limit+))

(deftype stack-choice-size ()
  ;; TODO: is this actually right?  check on frame size limit vs choice point
  ;; size limit...
  `(integer 7 ,+stack-frame-size-limit+))

(deftype stack-frame-argcount ()
  'arity)

(deftype continuation-pointer ()
  'code-index)

(deftype environment-pointer ()
  'stack-index)

(deftype backtrack-pointer ()
  'stack-index)


(deftype stack-frame-word ()
  '(or
    environment-pointer ; CE
    continuation-pointer ; CP
    stack-frame-argcount ; N
    cell)) ; Yn

(deftype stack-choice-word ()
  '(or
    environment-pointer ; CE
    backtrack-pointer ; B
    continuation-pointer ; CP, BP
    stack-frame-argcount ; N
    trail-index ; TR
    heap-index ; H
    cell)) ; An

(deftype stack-word ()
  '(or stack-frame-word stack-choice-word))


;;;; Sanity Checks
;;; The values on the WAM stack are a bit of a messy situation.  The WAM store
;;; is defined as an array of cells, but certain things on the stack aren't
;;; actually cells (e.g. the stored continuation pointer).
;;;
;;; This shouldn't be a problem (aside from being ugly) as long as our `cell`
;;; type is big enough to hold the values of these non-cell things.  So let's
;;; just make sure that's the case...
(defun sanity-check-stack-type (type)
  (assert (subtypep type 'cell) ()
    "Type ~A is too large to fit into a cell!"
    type)
  (values))

(sanity-check-stack-type 'stack-frame-argcount)
(sanity-check-stack-type 'environment-pointer)
(sanity-check-stack-type 'continuation-pointer)
(sanity-check-stack-type 'backtrack-pointer)
(sanity-check-stack-type 'trail-index)
(sanity-check-stack-type 'stack-word)


