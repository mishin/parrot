/* exceptions.h
 *  Copyright (C) 2001-2008, The Perl Foundation.
 *  SVN Info
 *     $Id$
 *  Overview:
 *     define the internal interpreter exceptions
 *  Data Structure and Algorithms:
 *  History:
 *  Notes:
 *  References:
 */

#ifndef PARROT_EXCEPTIONS_H_GUARD
#define PARROT_EXCEPTIONS_H_GUARD

#include "parrot/compiler.h"

/* Prototypes */

/* Exception Types
 * the first types are real exceptions and have Python exception
 * names.
 */

/* &gen_from_enum(except_types.pasm) */
typedef enum {
        EXCEPTION_BAD_BUFFER_SIZE,
        EXCEPTION_MISSING_ENCODING_NAME,
        EXCEPTION_INVALID_STRING_REPRESENTATION,
        EXCEPTION_ICU_ERROR,
        EXCEPTION_UNIMPLEMENTED,

        EXCEPTION_NULL_REG_ACCESS,
        EXCEPTION_NO_REG_FRAMES,
        EXCEPTION_SUBSTR_OUT_OF_STRING,
        EXCEPTION_ORD_OUT_OF_STRING,
        EXCEPTION_MALFORMED_UTF8,
        EXCEPTION_MALFORMED_UTF16,
        EXCEPTION_MALFORMED_UTF32,
        EXCEPTION_INVALID_CHARACTER,
        EXCEPTION_INVALID_CHARTYPE,
        EXCEPTION_INVALID_ENCODING,
        EXCEPTION_INVALID_CHARCLASS,
        EXCEPTION_NEG_REPEAT,
        EXCEPTION_NEG_SUBSTR,
        EXCEPTION_NEG_SLEEP,
        EXCEPTION_NEG_CHOP,
        EXCEPTION_INVALID_OPERATION,
        EXCEPTION_ARG_OP_NOT_HANDLED,
        EXCEPTION_KEY_NOT_FOUND,
        EXCEPTION_JIT_UNAVAILABLE,
        EXCEPTION_EXEC_UNAVAILABLE,
        EXCEPTION_INTERP_ERROR,
        EXCEPTION_PREDEREF_LOAD_ERROR,
        EXCEPTION_PARROT_USAGE_ERROR,
        EXCEPTION_PIO_ERROR,
        EXCEPTION_PARROT_POINTER_ERROR,
        EXCEPTION_DIV_BY_ZERO,
        EXCEPTION_PIO_NOT_IMPLEMENTED,
        EXCEPTION_ALLOCATION_ERROR,
        EXCEPTION_INTERNAL_PANIC,
        EXCEPTION_OUT_OF_BOUNDS,
        EXCEPTION_JIT_ERROR,
        EXCEPTION_EXEC_ERROR,
        EXCEPTION_ILL_INHERIT,
        EXCEPTION_NO_PREV_CS,
        EXCEPTION_NO_CLASS,
        EXCEPTION_LEX_NOT_FOUND,
        EXCEPTION_PAD_NOT_FOUND,
        EXCEPTION_ATTRIB_NOT_FOUND,
        EXCEPTION_GLOBAL_NOT_FOUND,
        EXCEPTION_EXTERNAL_ERROR,
        EXCEPTION_METH_NOT_FOUND,
        EXCEPTION_VTABLE_NOT_FOUND,
        EXCEPTION_WRITE_TO_CONSTCLASS,
        EXCEPTION_NOSPAWN,
        EXCEPTION_INTERNAL_NOT_IMPLEMENTED,
        EXCEPTION_ERR_OVERFLOW,
        EXCEPTION_LOSSY_CONVERSION,
        EXCEPTION_ROLE_COMPOSITION_METH_CONFLICT,
        EXCEPTION_UNEXPECTED_NULL,
        EXCEPTION_LIBRARY_ERROR,
        EXCEPTION_LIBRARY_NOT_LOADED,
        EXCEPTION_SYNTAX_ERROR,
        EXCEPTION_MALFORMED_PACKFILE,

        CONTROL_RETURN,
        CONTROL_OK,
        CONTROL_BREAK,
        CONTROL_CONTINUE,
        CONTROL_ERROR,
        CONTROL_TAKE,

        CONTROL_LOOP_NEXT,
        CONTROL_LOOP_LAST,
        CONTROL_LOOP_REDO
} exception_type_enum;

/* &end_gen */

/* &gen_from_enum(except_severity.pasm) subst(s/(\w+)/uc($1)/e) */

typedef enum {
    EXCEPT_normal  = 0,
    EXCEPT_warning = 1,
    EXCEPT_error   = 2,
    EXCEPT_severe  = 3,
    EXCEPT_fatal   = 4,
    EXCEPT_doomed  = 5,
    EXCEPT_exit    = 6
} exception_severity;

/* &end_gen */

/* HEADERIZER BEGIN: src/exceptions.c */
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */

PARROT_EXPORT
PARROT_DOES_NOT_RETURN
void exit_fatal(int exitcode, ARGIN(const char *format), ...)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_DOES_NOT_RETURN_WHEN_FALSE
void Parrot_assert(
    INTVAL condition,
    ARGIN(const char *condition_string),
    ARGIN(const char *file),
    unsigned int line)
        __attribute__nonnull__(2)
        __attribute__nonnull__(3);

PARROT_EXPORT
PARROT_DOES_NOT_RETURN
void Parrot_confess(
    ARGIN(const char *cond),
    ARGIN(const char *file),
    unsigned int line)
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
void Parrot_ex_add_c_handler(PARROT_INTERP, ARGIN(Parrot_runloop *jp))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_CAN_RETURN_NULL
PMC * Parrot_ex_build_exception(PARROT_INTERP,
    INTVAL severity,
    long error,
    ARGIN_NULLOK(STRING *msg))
        __attribute__nonnull__(1);

PARROT_EXPORT
size_t Parrot_ex_calc_handler_offset(PARROT_INTERP)
        __attribute__nonnull__(1);

PARROT_EXPORT
void Parrot_ex_mark_unhandled(PARROT_INTERP, ARGIN(PMC *exception))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_DOES_NOT_RETURN
void Parrot_ex_rethrow_from_c(PARROT_INTERP, ARGIN(PMC *exception))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_WARN_UNUSED_RESULT
PARROT_CAN_RETURN_NULL
opcode_t * Parrot_ex_rethrow_from_op(PARROT_INTERP, ARGIN(PMC *exception))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_DOES_NOT_RETURN
void Parrot_ex_throw_from_c(PARROT_INTERP, ARGIN(PMC *exception))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_DOES_NOT_RETURN
void Parrot_ex_throw_from_c_args(PARROT_INTERP,
    SHIM(void *ret_addr),
    int exitcode,
    ARGIN(const char *format),
    ...)
        __attribute__nonnull__(1)
        __attribute__nonnull__(4);

PARROT_EXPORT
PARROT_CAN_RETURN_NULL
opcode_t * Parrot_ex_throw_from_op(PARROT_INTERP,
    ARGIN(PMC *exception),
    ARGIN_NULLOK(void *dest))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_EXPORT
PARROT_CAN_RETURN_NULL
opcode_t * Parrot_ex_throw_from_op_args(PARROT_INTERP,
    ARGIN_NULLOK(void *dest),
    int ex_type,
    ARGIN(const char *format),
    ...)
        __attribute__nonnull__(1)
        __attribute__nonnull__(4);

PARROT_DOES_NOT_RETURN
void die_from_exception(PARROT_INTERP, ARGIN(PMC *exception))
        __attribute__nonnull__(1)
        __attribute__nonnull__(2);

PARROT_DOES_NOT_RETURN
void do_panic(
    NULLOK_INTERP,
    ARGIN_NULLOK(const char *message),
    ARGIN_NULLOK(const char *file),
    unsigned int line);

void Parrot_print_backtrace(void);
#define ASSERT_ARGS_exit_fatal assert(format);
#define ASSERT_ARGS_Parrot_assert assert(condition_string); \
                                  assert(file);
#define ASSERT_ARGS_Parrot_confess assert(cond); \
                                   assert(file);
#define ASSERT_ARGS_Parrot_ex_add_c_handler assert(interp); \
                                            assert(jp);
#define ASSERT_ARGS_Parrot_ex_build_exception assert(interp);
#define ASSERT_ARGS_Parrot_ex_calc_handler_offset assert(interp);
#define ASSERT_ARGS_Parrot_ex_mark_unhandled assert(interp); \
                                             assert(exception);
#define ASSERT_ARGS_Parrot_ex_rethrow_from_c assert(interp); \
                                             assert(exception);
#define ASSERT_ARGS_Parrot_ex_rethrow_from_op assert(interp); \
                                              assert(exception);
#define ASSERT_ARGS_Parrot_ex_throw_from_c assert(interp); \
                                           assert(exception);
#define ASSERT_ARGS_Parrot_ex_throw_from_c_args assert(interp); \
                                                assert(format);
#define ASSERT_ARGS_Parrot_ex_throw_from_op assert(interp); \
                                            assert(exception);
#define ASSERT_ARGS_Parrot_ex_throw_from_op_args assert(interp); \
                                                 assert(format);
#define ASSERT_ARGS_die_from_exception assert(interp); \
                                       assert(exception);
#define ASSERT_ARGS_do_panic
#define ASSERT_ARGS_Parrot_print_backtrace
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */
/* HEADERIZER END: src/exceptions.c */

#define PANIC(interp, message) do_panic((interp), (message), __FILE__, __LINE__)

#ifdef NDEBUG
#  define PARROT_ASSERT(x) ((void)0)
#else
#  define PARROT_ASSERT(x) (x) ? ((void)0) : Parrot_confess(#x, __FILE__, __LINE__)
#endif

/* having a function version of this lets us put ASSERT_ARGS() at the top
 * of the list of local variables.  Thus, we can catch bad pointers before
 * any of the local initialization logic is run.  And it always returns 0,
 * so headerizer can define the ASSERT_ARGS_* macros like:
 * int _ASSERT_ARGS = PARROT_ASSERT_ARG(a) || PARROT_ASSERT_ARG(b) || ...
 */
static inline int PARROT_ASSERT_ARG(const void *x) {
    PARROT_ASSERT(x);
    return 0;
}
#define ASSERT_ARGS(a) ASSERT_ARGS_ ## a


#endif /* PARROT_EXCEPTIONS_H_GUARD */

/*
 * Local variables:
 *   c-file-style: "parrot"
 * End:
 * vim: expandtab shiftwidth=4:
 */
