;;; flymake-cpanfile.el --- flymake for cpanfile

;; Copyright (C) 2013 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-flymake-cpanfile
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Syntax check script is taken from URL below
;;   - https://github.com/moznion/syntastic-cpanfile

;;; Code:

(require 'flymake)

(defgroup flymake-cpanfile nil
  "Flaymake checking of cpanfile using Module::CPANfile"
  :prefix "flymake-cpanfile-"
  :group 'programming)

(defcustom flymake-cpanfile-check-script
  (if load-file-name
      (concat (file-name-directory load-file-name) "parse_cpanfile.pl")
    (concat default-directory "parse_cpanfile.pl"))
  "Path of cpanfile check script"
  :type 'file
  :group 'flymake-cpanfile)

(defvar flymake-cpanfile-err-line-patterns
  '(("^\\([^:]+\\):\\([^:]+\\):\\(.*\\)$" 1 2 nil 3)))

(defun flymake-cpanfile-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "perl" (list flymake-cpanfile-check-script local-file))))

;;;###autoload
(defun flymake-cpanfile-setup ()
  (set (make-local-variable 'flymake-err-line-patterns)
       flymake-cpanfile-err-line-patterns)
  (flymake-mode 1))

;;;###autoload
(push '("cpanfile\\'" flymake-cpanfile-init) flymake-allowed-file-name-masks)

(provide 'flymake-cpanfile)

;;; flymake-cpanfile.el ends here
