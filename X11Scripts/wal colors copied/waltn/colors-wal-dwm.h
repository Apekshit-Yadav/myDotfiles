static const char norm_fg[] = "#c8d3f5";
static const char norm_bg[] = "#1b1d2b";
static const char norm_border[] = "#444a73";

static const char sel_fg[] = "#c8d3f5";
static const char sel_bg[] = "#ff757f";
static const char sel_border[] = "#c8d3f5";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
