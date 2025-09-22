#ifndef PRINTF_H
#define PRINTF_H

#include "stdarg.h"

// 函数声明
void printf(const char *fmt, ...);
void clear_screen(void);
void goto_rc(int row, int col);
void cursor_up(int lines);
void cursor_down(int lines);
void cursor_right(int lines);
void cursor_left(int lines);
void save_cursor(void);
void restore_cursor(void);

void reset_color(void);
void set_fg_color(int color);
void set_bg_color(int color);
void set_color(int fg, int bg);
void color_red(void);
void color_green(void);
void color_yellow(void);
void color_blue(void);
void color_purple(void);
void color_cyan(void);
void color_reverse(void);
void clear_line(void);
#endif