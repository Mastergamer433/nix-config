(in-package #:nyxt-user)

(define-command-global youtube-play-current-page ()
  "Watch a Youtube video with mpv"
  (uiop:run-program
   (list "mpv" "--x11-name=mpvFullscreen" (render-url (url (current-buffer))))))
;; Let's create a function to hint videos, convert the url to a sting, and play them in MPV
(define-command-global hint-mpv ()
  "Show a set of element hints, and copy the URL of the user inputted one."
  (nyxt/web-mode:query-hints "Copy element URL"
                             (lambda (nyxt/web-mode::result)
                               ;; this converts the url to a string to be used in mpv
                               (let*
                                   ((url
                                      (format nil "~a"
                                              (url (first nyxt/web-mode::result)))))
                                 ;; here we take that string and pipe it into mpv
                                 (mpv url)))))

(define-configuration nyxt/style-mode:dark-mode
  ((style #.(cl-css:css
             '((*
                :background-color "black !important"
                :background-image "none !important"
                :color "white")
               (a
                :background-color "black !important"
                :background-image "none !important"
                :color "#7D8FA3 !important"))))))

(define-configuration buffer
  ((default-modes (append '(vi-normal-mode) %slot-default%))
   (external-editor-program '("emacsclient"))))

(define-configuration window
  ((message-buffer-style
    (str:concat
     %slot-default%
     (cl-css:css '((.nyxt-hint
		    :background-color "black" 
		    :border-style solid
		    :font-size "10pt"
		    :border-color "lighgrey"
		    :border-width "thin"
		    :color "white"
		    :opacity 1
		    :padding "2px 2px 2px 2px"
		    :border-radius "2px")
		   (body
		    :background-color "black"
		    :color "white")))))))

(define-configuration nyxt/web-mode:web-mode
  ((nyxt/web-mode:hints-alphabet "asdfjklö")
   (nyxt/web-mode::keymap-scheme
    ;; This will only works in >2.2.1. Change it to the hash-table way
    ;; below to make it work in <2.2.
    (nyxt::define-scheme (:name-prefix "web" :import %slot-default%)
      ;; If you want to have VI bindings overriden, just use
      ;; `scheme:vi-normal' or `scheme:vi-insert' instead of
      ;; `scheme:emacs'.
      scheme:vi-normal
      (list
       "g u y" 'copy-username
       "g p y" 'copy-password)))))

(defun replace-all (string part replacement &key (test #'char=))
  "Returns a new string in which all the occurences of the part 
is replaced with replacement."
  (with-output-to-string (out)
    (loop with part-length = (length part)
          for old-pos = 0 then (+ pos part-length)
          for pos = (search part string
                            :start2 old-pos
                            :test test)
          do (write-string string out
                           :start old-pos
                           :end (or pos (length string)))
          when pos do (write-string replacement out)
            while pos)))

(defun eval-in-emacs (&rest s-exps)
  "Evaluate S-EXPS with emacsclient."
  (let ((s-exps-string (replace-all
                        (write-to-string
                         `(progn ,@s-exps) :case :downcase)
                        ;; Discard the package prefix.
                        "nyxt::" "")))
    (format *error-output* "Sending to Emacs:~%~a~%" s-exps-string)
    (uiop:run-program
     (list "emacsclient" "--eval" s-exps-string))))

(define-command-global my/playing-around ()
     "Query ."
     (eval-in-emacs
        `(message "hello from Nyxt!")))
