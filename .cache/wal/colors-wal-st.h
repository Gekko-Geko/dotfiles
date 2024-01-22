const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#121019", /* black   */
  [1] = "#62867A", /* red     */
  [2] = "#CB966E", /* green   */
  [3] = "#3F6691", /* yellow  */
  [4] = "#BA6190", /* blue    */
  [5] = "#46AAB0", /* magenta */
  [6] = "#DEA69D", /* cyan    */
  [7] = "#d8d3d4", /* white   */

  /* 8 bright colors */
  [8]  = "#979394",  /* black   */
  [9]  = "#62867A",  /* red     */
  [10] = "#CB966E", /* green   */
  [11] = "#3F6691", /* yellow  */
  [12] = "#BA6190", /* blue    */
  [13] = "#46AAB0", /* magenta */
  [14] = "#DEA69D", /* cyan    */
  [15] = "#d8d3d4", /* white   */

  /* special colors */
  [256] = "#121019", /* background */
  [257] = "#d8d3d4", /* foreground */
  [258] = "#d8d3d4",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
