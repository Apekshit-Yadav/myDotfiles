const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0f241a", /* black   */
  [1] = "#46594C", /* red     */
  [2] = "#506759", /* green   */
  [3] = "#6B6654", /* yellow  */
  [4] = "#597164", /* blue    */
  [5] = "#67796D", /* magenta */
  [6] = "#73837A", /* cyan    */
  [7] = "#c3c8c5", /* white   */

  /* 8 bright colors */
  [8]  = "#5e746a",  /* black   */
  [9]  = "#46594C",  /* red     */
  [10] = "#506759", /* green   */
  [11] = "#6B6654", /* yellow  */
  [12] = "#597164", /* blue    */
  [13] = "#67796D", /* magenta */
  [14] = "#73837A", /* cyan    */
  [15] = "#c3c8c5", /* white   */

  /* special colors */
  [256] = "#0f241a", /* background */
  [257] = "#c3c8c5", /* foreground */
  [258] = "#c3c8c5",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
