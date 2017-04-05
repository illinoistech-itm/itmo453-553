(ns examplecom.etc.email
  (:require [riemann.email :refer :all]))

(def email (mailer {:host "smtp.gmail.com" :user "you@hawk.iit.edu" :pass "lovebunnies" :tls true :port 587 :from "riemann@example.com"}))
; URL to IIT student email https://ots.iit.edu/email/student-mail

