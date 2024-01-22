static const char norm_fg[] = "#d8d3d4";
static const char norm_bg[] = "#121019";
static const char norm_border[] = "#979394";

static const char sel_fg[] = "#121019";
static const char sel_bg[] = "#ff7f50";
static const char sel_border[] = "#ff7f50";

static const char urg_fg[] = "#d8d3d4";
static const char urg_bg[] = "#62867A";
static const char urg_border[] = "#62867A";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
