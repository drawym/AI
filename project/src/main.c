#include "at32f435_437_clock.h"
#include "at32f435_437_board.h"
#include "SEGGER_RTT.h"
#include "debug_log.h"
/**
  * @brief  Main program function
  * @param  None
  * @retval None
  */
int main(void)
{
  /* System clock configuration */
  system_clock_config();

  /* Initialize board (LEDs, buttons, delay) */
  at32_board_init();

  // // /* Infinite loop - toggle LED2 every 500ms */
  // // /* Initialize RTT */
  // SEGGER_RTT_ConfigUpBuffer(0, "Terminal", NULL, 0, SEGGER_RTT_MODE_BLOCK_IF_FIFO_FULL);

  /* Infinite loop - toggle LED2 every 2000ms */
  while (1)
  {
     // RTT 打印
    LOG0("Hello zzh 666\n");
    at32_led_toggle(LED2);
    delay_ms(100); //必须要100
  }
}
