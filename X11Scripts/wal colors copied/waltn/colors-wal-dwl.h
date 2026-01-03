/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x1b1d2bff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc8d3f5ff, 0x1b1d2bff, 0x444a73ff },
	[SchemeSel]  = { 0xc8d3f5ff, 0xc3e88dff, 0xff757fff },
	[SchemeUrg]  = { 0xc8d3f5ff, 0xff757fff, 0xc3e88dff },
};
