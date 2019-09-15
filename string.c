#include "uart_core.h"
#include "string.h"

size_t strlen(const char* str) {
        const char* s;
        for (s = str; *s; ++s) ;
        return (s - str);
}

void puts(const char* str) {
	hal_stdout_tx_strn(str, strlen(str));
	hal_stdout_tx_strn("\r\n", 2);
}

