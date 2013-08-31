//
//  vartable.h
//  w2mm
//
//  Created by Andriy Mykhaylyshyn on 8/31/13.
//  Copyright (c) 2013 Andriy Mykhaylyshyn. All rights reserved.
//

#ifndef w2mm_vartable_h
#define w2mm_vartable_h

typedef enum {
    VAR_NULL,
    VAR_STRING,
    VAR_NUMBER
} variable_type_t;

typedef struct {
    variable_type_t var_type;
    union {
        char *val_string;
        double val_number;
    } value;
} variable_t;

#ifdef __cplusplus
extern "C" {
#endif
    
int query_variable(const char *name, variable_t *value);
    
#ifdef __cplusplus
}
#endif

#endif
