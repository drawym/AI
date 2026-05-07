#ifndef _DEBUG_LOG_H
#define _DEBUG_LOG_H

#include "SEGGER_RTT.h"

#define LOG_DEBUG 1

#if LOG_DEBUG

#define LOG_PROTO(type,color,format,...)            \
        (SEGGER_RTT_SetTerminal(0),                 \
        SEGGER_RTT_printf(0,"  %s%s"format"\r\n%s", \
                          color,                    \
                          type,                     \
                          ##__VA_ARGS__,            \
                          RTT_CTRL_RESET))

#define LOG_PROT1(type,color,format,...)            \
        (SEGGER_RTT_SetTerminal(1),                 \
        SEGGER_RTT_printf(0,"  %s%s"format"\r\n%s", \
                          color,                    \
                          type,                     \
                          ##__VA_ARGS__,            \
                          RTT_CTRL_RESET))

/* 清屏*/
#define LOG0_CLEAR() SEGGER_RTT_WriteString(0, "  "RTT_CTRL_CLEAR)
#define LOG1_CLEAR() SEGGER_RTT_WriteString(1, "  "RTT_CTRL_CLEAR)

/* 无颜色日志输出 */
#define LOG0(format,...) LOG_PROTO("","",format,##__VA_ARGS__)
#define LOG1(format,...) LOG_PROT1("","",format,##__VA_ARGS__)

/* 有颜色格式日志输出 */
#define LOGG0(format,...) LOG_PROTO("G: ", RTT_CTRL_TEXT_BRIGHT_GREEN  , format, ##__VA_ARGS__) // 绿色
#define LOGY0(format,...) LOG_PROTO("Y: ", RTT_CTRL_TEXT_BRIGHT_YELLOW , format, ##__VA_ARGS__) // 黄色
#define LOGR0(format,...) LOG_PROTO("R: ", RTT_CTRL_TEXT_BRIGHT_RED    , format, ##__VA_ARGS__) // 红色
#define LOGB0(format,...) LOG_PROTO("B: ", RTT_CTRL_TEXT_BRIGHT_BLUE   , format, ##__VA_ARGS__) // 蓝色
#define LOGM0(format,...) LOG_PROTO("M: ", RTT_CTRL_TEXT_BRIGHT_MAGENTA, format, ##__VA_ARGS__) // 紫色
#define LOGC0(format,...) LOG_PROTO("C: ", RTT_CTRL_TEXT_BRIGHT_CYAN   , format, ##__VA_ARGS__) // 青色

#define LOGG1(format,...) LOG_PROT1("G: ", RTT_CTRL_TEXT_BRIGHT_GREEN  , format, ##__VA_ARGS__) // 绿色
#define LOGY1(format,...) LOG_PROT1("Y: ", RTT_CTRL_TEXT_BRIGHT_YELLOW , format, ##__VA_ARGS__) // 黄色
#define LOGR1(format,...) LOG_PROT1("R: ", RTT_CTRL_TEXT_BRIGHT_RED    , format, ##__VA_ARGS__) // 红色
#define LOGB1(format,...) LOG_PROT1("B: ", RTT_CTRL_TEXT_BRIGHT_BLUE   , format, ##__VA_ARGS__) // 蓝色
#define LOGM1(format,...) LOG_PROT1("M: ", RTT_CTRL_TEXT_BRIGHT_MAGENTA, format, ##__VA_ARGS__) // 紫色
#define LOGC1(format,...) LOG_PROT1("C: ", RTT_CTRL_TEXT_BRIGHT_CYAN   , format, ##__VA_ARGS__) // 青色

#else
#define LOG0(...)
#define LOG1(...)
#define LOG0_CLEAR(...)
#define LOG1_CLEAR(...)
#define LOG0(...)
#define LOGG0(...)
#define LOGY0(...)
#define LOGR0(...)
#define LOGB0(...)
#define LOGM0(...)
#define LOGC0(...)
#define LOGG1(...)
#define LOGY1(...)
#define LOGR1(...)
#define LOGB1(...)
#define LOGM1(...)
#define LOGC1(...)
#endif

#endif // !_DEBUG_LOG_H_

