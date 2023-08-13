.segment        "VECTORS": absolute
.ifdef TWOTRIS
        .addr   twotris
.else
        .addr   nmi
.endif
        .addr   reset
        .addr   irq

; End of "VECTORS" segment
.code
