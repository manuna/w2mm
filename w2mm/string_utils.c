//
//  string_utils.c
//  w2mm
//
//  Created by Andriy Mykhaylyshyn on 8/17/13.
//  Copyright (c) 2013 Andriy Mykhaylyshyn. All rights reserved.
//

#include <string.h>
#include <stdlib.h>

char * strdup2(const char *s1, const char *s2)
{
    char *result = NULL;
    if (s1 != NULL && s2 != NULL && s1 != s2) {
        result = (char *)malloc(strlen(s1) + strlen(s2) + 1);
        strcpy(result, "");
        strcat(result, s1);
        strcat(result, s2);
    } else if (s1 != NULL) {
        result = strdup(s1);
    } else if (s2 != NULL) {
        result = strdup(s2);
    }
    return result;
}
