#ifndef USR_LIB_H
#define USR_LIB_H

static inline int usr_strlen(const char *s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

static inline void usr_strcpy(char *dst, const char *src) {
    while ((*dst++ = *src++));
}

static inline void usr_strcat(char *dst, const char *src) {
    dst += usr_strlen(dst);
    usr_strcpy(dst, src);
}

static inline void usr_itoa(int num, char *str) {
    if (num == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }

    int i = 0;
    int is_negative = 0;

    if (num < 0) {
        is_negative = 1;
        num = -num;
    }

    while (num > 0) {
        str[i++] = (num % 10) + '0';
        num /= 10;
    }

    if (is_negative) {
        str[i++] = '-';
    }

    str[i] = '\0';

    int len = i;
    for (int j = 0; j < len / 2; j++) {
        char temp = str[j];
        str[j] = str[len - 1 - j];
        str[len - 1 - j] = temp;
    }
}

static inline void usr_build_string_with_int(char *buffer,
                                             const char *prefix,
                                             int num,
                                             const char *suffix) {
    char num_str[32];
    usr_itoa(num, num_str);

    usr_strcpy(buffer, prefix);
    usr_strcat(buffer, num_str);
    usr_strcat(buffer, suffix);
}
static inline void usr_build_string_with_two_ints(char *buffer,
                                                  const char *prefix1,
                                                  int num1,
                                                  const char *middle,
                                                  int num2,
                                                  const char *suffix) {
    char num_str1[32];
    char num_str2[32];

    usr_itoa(num1, num_str1);
    usr_itoa(num2, num_str2);

    usr_strcpy(buffer, prefix1);
    usr_strcat(buffer, num_str1);
    usr_strcat(buffer, middle);
    usr_strcat(buffer, num_str2);
    usr_strcat(buffer, suffix);
}

#endif // USR_LIB_H
