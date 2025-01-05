;; extends

(
    "return" @keyword.return
    (#set! "priority" 130)
)

(
    (escape_sequence) @string.escape
    (#set! "priority" 130)
)
