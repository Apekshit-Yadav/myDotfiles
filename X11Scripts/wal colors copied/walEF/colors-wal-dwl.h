/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x0f241aff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc3c8c5ff, 0x0f241aff, 0x5e746aff },
	[SchemeSel]  = { 0xc3c8c5ff, 0x506759ff, 0x46594Cff },
	[SchemeUrg]  = { 0xc3c8c5ff, 0x46594Cff, 0x506759ff },
};
