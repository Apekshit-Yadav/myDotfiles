const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1b1d2b", /* black   */
  [1] = "#ff757f", /* red     */
  [2] = "#c3e88d", /* green   */
  [3] = "#ffc777", /* yellow  */
  [4] = "#82aaff", /* blue    */
  [5] = "#c099ff", /* magenta */
  [6] = "#86e1fc", /* cyan    */
  [7] = "#828bb8", /* white   */

  /* 8 bright colors */
  [8]  = "#444a73",  /* black   */
  [9]  = "#ff8d94",  /* red     */
  [10] = "#c7fb6d", /* green   */
  [11] = "#ffd8ab", /* yellow  */
  [12] = "#9ab8ff", /* blue    */
  [13] = "#caabff", /* magenta */
  [14] = "#b2ebff", /* cyan    */
  [15] = "#c8d3f5", /* white   */

  /* special colors */
  [256] = "#222436", /* background */
  [257] = "#c8d3f5", /* foreground */
  [258] = "#c8d3f5",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
