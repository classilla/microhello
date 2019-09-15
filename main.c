#include "uart_core.h"
#include "string.h"

int main(int argc, char** argv) {
	// The head script sends whether QEMU has been detected in r3, which
	// is the first argument to main() (i.e., argc).
	uart_init_ppc(argc);

	puts("PowerPC to the People");
	__asm__("wait 0\n");
	return 0;
}
