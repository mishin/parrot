#ifndef __DEBUG_H
#define __DEBUG_H

#define DEBUG_PARROT 0x0001
#define DEBUG_LEXER  0x0002
#define DEBUG_PARSER 0x0004
#define DEBUG_IMC    0x0008
#define DEBUG_CFG    0x0010
#define DEBUG_OPT1   0x0020
#define DEBUG_OPT2   0x0040

#define DEBUG_PBC    0x1000
#define DEBUG_PBC_CONST    0x2000
#define DEBUG_PBC_FIXUP    0x4000

void fatal(int code, const char *func, const char *fmt, ...);
void fataly(int code, const char *func, int line, const char *fmt, ...);
void warning(Parrot_Interp interpreter, const char *func, const char *fmt, ...);
void debug(Parrot_Interp interpreter, int level, const char *fmt, ...);
void info(Parrot_Interp interpreter, int level, const char *fmt, ...);

void dump_instructions(Parrot_Interp);
void dump_cfg(Parrot_Interp);
void dump_loops(Parrot_Interp);
void dump_labels(Parrot_Interp);
void dump_symreg(Parrot_Interp);
void dump_interference_graph(Parrot_Interp);
void dump_dominators(Parrot_Interp);
void dump_liveness_status(Parrot_Interp);
void dump_liveness_status_var(Parrot_Interp, SymReg*);

#endif
