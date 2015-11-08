#ifndef PGASM_H
#define PGASM_H

#include <stddef.h>

int char_is_digit(const int ch);
int char_is_space(const int ch);
int char_is_alpha(const int ch);
int char_is_alnum(const int ch);

void exit_success(void);
void exit_failure(void);
int pgrandom(const int range);
void seedrandom(void);

int get_char(void);
int put_char(const int c);
int put_string(const char * s);
int get_string(const char * s, const size_t length);
void print_newline(void);
void put_int(const int n);
int get_int(void);
int get_char_line(void);

int intlog(const int n, const int base);

int string_length(const char * s);
int string_to_int(const char * s);
void string_rev(char * s);
void int_to_string(const int n, char * s);

#endif      /*  PGASM_H  */
