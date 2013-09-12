//
//  vartable.c
//  w2mm
//
//  Created by Andriy Mykhaylyshyn on 8/31/13.
//  Copyright (c) 2013 Andriy Mykhaylyshyn. All rights reserved.
//

#include <stddef.h>
#include "vartable.h"

int query_variable(const char *name, variable_t *value)
{
    if (value == NULL) {
        return -1;
    }
    
    value->var_type = VAR_NULL;
    value->value.val_integer = 0;
    return 0;
}
