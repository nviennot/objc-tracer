#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>
#include <stdarg.h>

#define FUNC(symbol, prototype) void *old_##symbol;
#include "objc_funcs.h"
#undef FUNC

void func_init(void)
{
	static int init_done;
	if (init_done)
		return;
	init_done = 1;

#define FUNC(symbol, prototype)						\
	old_##symbol = dlsym(RTLD_NEXT, #symbol);			\
	if (old_##symbol == NULL) {					\
		fprintf(stderr, "Cannot hijack %s\n", #symbol);		\
		abort();						\
	}

#include "objc_funcs.h"
#undef FUNC

}

struct fixup {
	void *dummy;
	SEL sel;
};

static void msg_debug(const char *class_name, const char *method_name)
{
	fprintf(stderr, "-objc->    %s::%s()\n", class_name, method_name);
}

void msg_debug_regular(id self, SEL op)
{
	msg_debug(object_getClassName(self), sel_getName(op));
}

void msg_debug_fixup(id self, struct fixup *fixup)
{
	msg_debug(object_getClassName(self), sel_getName(fixup->sel));
}

void msg_debug_fpret(id self, SEL op)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_fpret_fixup(id self, struct fixup *fixup)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_fpret2(id self, SEL op)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_fpret2_fixup(id self, struct fixup *fixup)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_stret(id self, SEL op)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_stret_fixup(id self, struct fixup *fixup)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_super(struct objc_super *super, SEL op)
{

	msg_debug(object_getClassName(super->receiver), sel_getName(op));
}

void msg_debug_super_fixup(struct objc_super *super, struct fixup *fixup)
{
	msg_debug(object_getClassName(super->receiver), sel_getName(fixup->sel));
}

void msg_debug_super_stret(id self, SEL op)
{
	fprintf(stderr, "%s\n", __func__);
}

void msg_debug_super_stret_fixup(id self, struct fixup *fixup)
{
	fprintf(stderr, "%s\n", __func__);
}
