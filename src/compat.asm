.if .defined(CNROM) & .defined(SCROLLTRIS)
.error "CNROM is not compatible with Scrolltris"
.endif

.if .defined(PENGUIN) & .defined(SCROLLTRIS)
.error "Penguin Line Clear is not compatible with Scrolltris"
.endif

.if .defined(PENGUIN) & .defined(DASMETER)
.error "Penguin Line Clear is not compatible with DAS meter"
.endif

.if .defined(ANYDAS) & .defined(DASMETER)
.error "Anydas is not compatible with DAS meter"
.endif
