(in-package :stumpwm)
(setf *default-package* :stumpwm)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4004
                     :style swank:*communication-style*
                     :dont-close t)

(setf *startup-message* NIL
      *suppress-abort-messages* t
      *shell-program* (getenv "SHELL"))

(run-shell-command "urxvtd &")
(run-shell-command "picom -b &")
(run-shell-command "setxkbmap -layout br -option ctrl:swapcaps_hyper &")
(run-shell-command "xsetroot -cursor_name left_ptr &")
(run-shell-command "feh --bg-fill ~/img/papes/laptop/gnu-float.png")

(defun window-cls-present-p (win-cls &optional all-groups)
  "Tell if a window (by class) is present"
  (let ((windows (group-windows (if all-groups (current-screen) (current-group)))))
    (member win-cls (mapcar #'window-class windows) :test #'string-equal)))

(defun run-or-raise-prefer-group (cmd win-cls)
  "If there are windows in the same class, cycle in those. Otherwise call
run-or-raise with group search t."
  (if (window-cls-present-p win-cls)
      (run-or-raise cmd `(:class ,win-cls) nil T)
      (run-or-raise cmd `(:class ,win-cls) T T)))

(add-to-load-path "~/.stumpwm.d/modules/")

(set-prefix-key (kbd "s-c"))


(define-key *top-map* (kbd "s-e") "exec emacsclient -c")
(define-key *top-map* (kbd "s-r") "quit-confirm")
(define-key *top-map* (kbd "s-RET") "exec urxvtc")
(define-key *top-map* (kbd "s-g") "exec urxvtc -e gotop")
(define-key *top-map* (kbd "s-w") "run-or-raise-firefox")

(defcommand run-or-raise-firefox () ()
  (run-or-raise-prefer-group "firefox" "Firefox"))

(define-key *top-map* (kbd "s-b") "exec switch")
(define-key *top-map* (kbd "s-x") "exec dmenu_run")
(define-key *top-map* (kbd "s-o") "other")
(define-key *top-map* (kbd "s-q") "delete")
(define-key *top-map* (kbd "s-j") "eval")

(defvar *window-and-frame-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "0") "remove")
    (define-key m (kbd "2") "vsplit")
    (define-key m (kbd "3") "hsplit")
    (define-key m (kbd "o") "fother")
    (define-key m (kbd "b") "windowlist")
    (define-key m (kbd "H-b") "frame-windowlist")
    m))
(define-key *top-map* (kbd "H-x") '*window-and-frame-bindings*)

(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec brightnessctl set 5%-")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec brightnessctl set +5%")

(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec pamixer -d 5")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec pamixer -i 5")
(define-key *top-map* (kbd "XF86AudioMute") "exec pamixer --toggle-mute")

(setf (group-name (car (screen-groups (current-screen)))) "I")
(run-commands "gnewbg II" "gnewbg III" "gnewbg  III" "gnewbg IV" "gnewbg V")

(define-key *top-map* (kbd "s-1") "gselect 1")
(define-key *top-map* (kbd "s-2") "gselect 2")
(define-key *top-map* (kbd "s-3") "gselect 3")
(define-key *top-map* (kbd "s-4") "gselect 4")
(define-key *top-map* (kbd "s-5") "gselect 5")

(define-key *top-map* (kbd "s-!") "gmove 1")
(define-key *top-map* (kbd "s-@") "gmove 2")
(define-key *top-map* (kbd "s-#") "gmove 3")
(define-key *top-map* (kbd "s-$") "gmove 4")
(define-key *top-map* (kbd "s-%") "gmove 5")

(ql:quickload "swm-gaps")

(setf swm-gaps:*inner-gaps-size* 10
      swm-gaps:*outer-gaps-size* 10
      swm-gaps:*head-gaps-size* 10)

(swm-gaps:toggle-gaps)

(define-key *root-map* (kbd "t") "toggle-gaps")

(ql:quickload "battery-portable")

(setf *screen-mode-line-format* (list "[%d] [^B%n^b]%W  [^B%B^b]")
      *window-format* "%m%n%s%c"
      *time-modeline-string* "%m/%e %k:%M"
      *mode-line-foreground-color* "#dddddd"
      *mode-line-background-color* "#202020"
      *mode-line-border-color* "#dddddd"
      *mode-line-position* :top
      *mode-line-pad-x* 5
      *mode-line-pad-y* 5
      *mode-line-timeout* 1)

(mode-line)

(define-key *root-map* (kbd "SPC") "mode-line")

(defcommand monocle () ()
  "Toggles both the modeline and gaps"
  (swm-gaps:toggle-gaps)
  (mode-line))

(define-key *top-map* (kbd "s-SPC") "monocle")

(setf *window-border-style* :tight
      *ignore-wm-inc-hints* NIL)
      ;; *maxsize-border-width* 1
      ;; *normal-border-width* 1
      ;; *transient-border-width*)

(set-win-bg-color "#202020")
(set-unfocus-color "#202020")
(set-focus-color "#dddddd")
