typedef unsigned char uint8_t;
typedef unsigned long int uintptr_t;
typedef unsigned long int size_t;
typedef unsigned long long uint64_t;

#define USE_QEMU_CONSOLE 1
#define USE_HW_CONSOLE 0

void uart_init_ppc(int qemu);
int hal_stdin_rx_chr(void);
void hal_stdout_tx_strn(const char *str, size_t len);
