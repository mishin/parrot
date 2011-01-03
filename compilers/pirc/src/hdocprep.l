%top{

/* ex: set ro ft=c:
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 *
 * This file is generated automatically by the Parrot build process
 * from the file compilers/pirc/new/hdocprep.l.
 *
 * Any changes made here will be lost!
 *
*/

/* HEADERIZER HFILE: none */
/* HEADERIZER STOP */

#ifndef __STDC_VERSION__
#  define __STDC_VERSION__ 0
#endif

#ifndef YY_NO_UNISTD_H
#  define YY_NO_UNISTD_H
#endif

}


%{

/*
 * Copyright (C) 2007-2009, Parrot Foundation.
 */

/*
 * This pre-processor processes all heredoc strings into
 * normal strings. Newline characters are escaped.
 * POD comments and line comments are filtered out.
 *
 * This pre-processor also handles the C<.include> directive.
 * This is necessary, as all files being compiled as a side-effect
 * must have their heredocs flattened.
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include "parrot/parrot.h"
#include "parrot/embed.h"
#include "pirheredoc.h"


/* don't bother to generate and include the header file;
 * we don't need it, really. Just some prototypes declarations needed.
 */
int   yylex_init(yyscan_t * yyscanner);
int   yyget_column(yyscan_t yyscanner);
void  yyset_column(int col, yyscan_t yyscanner);
char *yyget_text(yyscan_t yyscanner);
void  yyset_in(FILE *fp, yyscan_t yyscanner);
int   yylex_destroy(yyscan_t yyscanner);
int   yylex(yyscan_t yyscanner);
int   yyget_lineno(yyscan_t yyscanner);



/* disable some warnings that can't be fixed, as the code is generated. */
#ifdef _WIN32
#  pragma warning (disable:4018)
#  pragma warning (disable:4244)
#endif

/* declare the prototype of yylex */
#define YY_DECL int yylex(yyscan_t yyscanner)


/* all globals are collected in this structure which
 * is set in yyscan_t's "extra" field, available through
 * yy{get,set}_extra() function.
 */
typedef struct global_state {
    int             errors;
    char           *heredoc;       /* heredoc string buffer */
    char           *linebuffer;    /* buffer to save the 'rest of the line'
                                      before scanning a heredoc */
    char           *delimiter;     /* buffer to save the delimiter of the
                                      heredoc string being scanned */
    char           *filename;      /* name of the file being scanned */
    YY_BUFFER_STATE file_buffer;   /* needed to store the ref. to the file
                                      when scanning a string buffer */

    FILE           *outfile;        /* output file; or STDOUT if no file is specified */

    PARROT_INTERP;

} global_state;

/* accessor methods for setting and getting the lexer_state */
#define YY_EXTRA_TYPE  struct global_state *

extern YY_EXTRA_TYPE  yyget_extra(yyscan_t scanner);
extern void           yyset_extra(YY_EXTRA_TYPE lexer , yyscan_t scanner);



/*

=head1 FUNCTIONS

=over 4

=item C<static void
lex_error(yyscan_t yyscanner, char const * const message, ...)>

Emit an error message, increment error counter.

=cut

*/
static void
lex_error(yyscan_t yyscanner, NOTNULL(char const * const message), ...) {
    global_state * const state  = yyget_extra(yyscanner);
    int                  lineno = yyget_lineno(yyscanner);
    va_list              arg_ptr;

    fprintf(stderr, "\nHeredoc pre-processor error in '%s' (line %d): ", state->filename, lineno);

    va_start(arg_ptr, message);
    vfprintf(stderr, message, arg_ptr);
    va_end(arg_ptr);

    puts("");

    ++state->errors;
}




/*

=item C<static global_state *
init_global_state(char * const filename, FILE *outfile)>

Create and initialize a global_state structure, containing all 'global'
variables that are needed during the scanning.

=cut

*/
PARROT_MALLOC
PARROT_WARN_UNUSED_RESULT
PARROT_CANNOT_RETURN_NULL
static global_state *
init_global_state(PARROT_INTERP, NOTNULL(char * const filename), NOTNULL(FILE *outfile)) {
    global_state *state = (global_state *)mem_sys_allocate(sizeof (global_state));
    state->filename     = filename;
    state->heredoc      = NULL;
    state->linebuffer   = NULL;
    state->delimiter    = NULL;
    state->file_buffer  = NULL;
    state->errors       = 0;
    state->outfile      = outfile;
    state->interp       = interp;

    return state;
}

/*

=item C<static void
destroy_global_state(global_state * state)>

Free all memory of the global state structure.

=cut

*/
static void
destroy_global_state(NOTNULL(global_state *state)) {
    if (state->linebuffer)
        mem_sys_free(state->linebuffer);
    if (state->heredoc)
        mem_sys_free(state->heredoc);

    mem_sys_free(state);
    state = NULL;
}


/*

=item C<void
process_heredocs(char * const filename, FILE *outputfile)>

Scan the file C<filename> for heredoc strings, and write the I<normalized> heredoc
strings to the file C<outputfile>. The scan session uses a fresh C<yyscan_t>
object, so any nested (recursive, in a way) calls of this function are handled
fine, as each invocation has its own state. After the file C<filename> is processed,
all resources are released.

=cut

*/
void
process_heredocs(PARROT_INTERP, NOTNULL(char * const filename), NOTNULL(FILE *outfile)) {
    yyscan_t      yyscanner;
    global_state *state = NULL;
    FILE         *fp;

    /* open the file */
    fp = fopen(filename, "r");

    if (fp == NULL) {
        fprintf(stderr, "heredoc preprocessor: error opening file '%s'\n", filename);
        exit(EXIT_FAILURE);
    }

    /* initialize a yyscan_t object */
    yylex_init(&yyscanner);
    /* set the scanner to a string buffer and go parse */
    yyset_in(fp, yyscanner);

    state = init_global_state(interp, filename, outfile);

    yyset_extra(state, yyscanner);

    /* the lexer never returns anything, only call it once. Don't give a YYSTYPE object. */
    yylex(yyscanner);

    destroy_global_state(state);

    /* clean up after playing */
    yylex_destroy(yyscanner);
}


/*

=back

=cut

*/




%}

%option reentrant
%option noyywrap
%option nounput

%option never-interactive

%option stack
%option debug
%option warn
%option noyy_top_state
%option outfile="hdocprep.c"
%option yylineno

%pointer

%x POD
%x INCLUDE
%x SAVE_REST_OF_LINE
%x SAVE_REST_AGAIN
%x HEREDOC_STRING
%x SCAN_STRING


WS             [\t\f\r\x1a ]
EOL            \r?\n
DQ_STRING       \"(\\.|[^"\\\n])*\"
SQ_STRING       \'[^'\n]*\'
Q_STRING       {SQ_STRING}|{DQ_STRING}
LINECOMMENT    [#].*{EOL}?

%%

<*>{LINECOMMENT}        { /* ignore line comments */ }

<INITIAL>^"=cut"{EOL}   { /* ignore a "=cut" if it's not in a POD comment */ }

<INITIAL>^"=".*{EOL}    { yy_push_state(POD, yyscanner); }


<POD>^"=cut".*{EOL}     { /* end of POD comment */
                          yy_pop_state(yyscanner);
                        }

<POD>.*{EOL}            { /* ignore pod comments */ }

<POD><<EOF>>            { /* we're scanning a POD comment, but encountered end-of-file. */
                          lex_error(yyscanner, "POD comment not closed!");
                          yyterminate();
                        }

<INITIAL>{EOL}          { fprintf(yyget_extra(yyscanner)->outfile, "\n"); }


<INITIAL>"<<"{Q_STRING} {
                          global_state * const state = yyget_extra(yyscanner);

                          state->delimiter = (char *)mem_sys_allocate_zeroed((yyleng - 4 + 1)
                                                                             * sizeof (char));

                          strncpy(state->delimiter, yytext + 3, yyleng - 4);

                          state->heredoc = (char *)mem_sys_allocate_zeroed(3 * sizeof (char));

                          strcpy(state->heredoc, "\\n");

                          BEGIN(SAVE_REST_OF_LINE);

                        }


<SAVE_REST_OF_LINE>.*{EOL}  { /* match the rest of the line */
                              global_state * const state = yyget_extra(yyscanner);

                              state->linebuffer = (char *)mem_sys_allocate_zeroed((yyleng + 2)
                                                                                  * sizeof (char));

                              sprintf(state->linebuffer, "%s\n", yytext);

                              BEGIN(HEREDOC_STRING);

                            }

<SAVE_REST_AGAIN>.*{EOL}    { /* match the rest of the line */
                              global_state * const state = yyget_extra(yyscanner);

                              /* at this point we're saving the rest of the line again,
                               * so we were scanning the line buffer; free this now to
                               * prevent memory leaks.
                               */
                              PARROT_ASSERT(state->linebuffer != NULL);
                              mem_sys_free(state->linebuffer);

                              state->linebuffer = (char *)mem_sys_allocate_zeroed((yyleng + 2)
                                                                                  * sizeof (char));

                              sprintf(state->linebuffer, "%s\n", yytext);

                              yy_switch_to_buffer(state->file_buffer, yyscanner);

                              BEGIN(HEREDOC_STRING);

                            }


<HEREDOC_STRING>{EOL}       {
                              global_state * const state = yyget_extra(yyscanner);

                              int len = strlen(state->heredoc);

                              /* allocate enough space for the current heredoc and an
                               * escaped newline character, + the NULL character.
                               */
                              char *temp = (char *)mem_sys_allocate_zeroed((len + 1 + 2)
                                                                           * sizeof (char));

                              sprintf(temp, "%s\\n", state->heredoc);

                              mem_sys_free(state->heredoc);

                              state->heredoc = temp;

                            }

<HEREDOC_STRING>.*{EOL}    {
                             global_state * const state = yyget_extra(yyscanner);

                             /* remove the newline character */
                             /* can this be done through #ifdef, to prevent checks? */
                             if (yytext[yyleng - 2] == '\r')
                                 yytext[yyleng - 2] = '\0';
                             else /* yytext[yyleng - 1] is '\n'. */
                                 yytext[yyleng - 1] = '\0';

                             if (strcmp(state->delimiter, yytext) == 0) { /* delimiter found? */

                                 /* done with the delimiter */
                                 mem_sys_free(state->delimiter);
                                 state->delimiter = NULL;

                                 /* we're going to scan from the linebuffer, save the current
                                  * buffer for later (to restore it).
                                  */
                                 state->file_buffer = YY_CURRENT_BUFFER;

                                 /* print the flattened heredoc string */
                                 fprintf(yyget_extra(yyscanner)->outfile, "\"%s\"", state->heredoc);

                                 mem_sys_free(state->heredoc);
                                 state->heredoc = NULL;

                                 /* now continue with scanning the string that we saved */
                                 BEGIN(SCAN_STRING);

                                 yy_scan_string(state->linebuffer, yyscanner);
                             }
                             else { /* nope, this is part of the heredoc; save this line */

                                 int len = strlen(state->heredoc);

                                 char *temp = (char *)mem_sys_allocate((len + yyleng + 1 + 2)
                                                                       * sizeof (char));

                                 sprintf(temp, "%s%s\\n", state->heredoc, yytext);

                                 mem_sys_free(state->heredoc);

                                 state->heredoc = temp;
                             }
                           }

<HEREDOC_STRING><<EOF>>     { /* end of file while reading heredoc */
                              lex_error(yyscanner, "runaway heredoc string");
                              yyterminate();
                            }

<SCAN_STRING>"<<"{Q_STRING} { /* a 'nested' heredoc string */
                              global_state *state = yyget_extra(yyscanner);

                              PARROT_ASSERT(state->delimiter == NULL);

                              /* <<"FOO", only save the characters 'F','O','O'. */
                              state->delimiter = (char *)mem_sys_allocate_zeroed((yyleng - 4 + 1)
                                                                                 * sizeof (char));
                              /* strncpy adds the NULL char., according to the spec. */
                              strncpy(state->delimiter, yytext + 3, yyleng - 4);

                              state->heredoc = (char *)mem_sys_allocate_zeroed(3 * sizeof (char));

                              /* an empty heredoc has at least a newline */
                              strcpy(state->heredoc, "\\n");

                              BEGIN(SAVE_REST_AGAIN);
                            }

<SCAN_STRING>{EOL}          { /* do nothing */ }

<SCAN_STRING>.              { fprintf(yyget_extra(yyscanner)->outfile, "%s", yytext); }

<SCAN_STRING><<EOF>>        {
                              global_state * const state = yyget_extra(yyscanner);

                              /* switch back to file; */
                              yy_switch_to_buffer(state->file_buffer, yyscanner);

                              /* done with scanning the rest of the line; free its memory */
                              mem_sys_free(state->linebuffer);
                              /* and make sure there's no stray pointers */
                              state->linebuffer  = NULL;

                              state->file_buffer = NULL;

                              /* make sure the PIR parser will report the right line numbers,
                               * in case of errors; as the heredoc string, which was X lines,
                               * is now flattened into 1 line, the line number must be adjusted.
                               */
                              fprintf(state->outfile, "\n.line %d\n", yyget_lineno(yyscanner));

                              BEGIN(INITIAL);
                            }



<INITIAL><<EOF>>            { /* end of file */
                              yyterminate();
                            }

<INITIAL>".include"         { /* .include directives must be handled here */
                              yy_push_state(INCLUDE, yyscanner);
                            }

<INCLUDE>{WS}               { /* skip whitespace */ }

<INCLUDE>{Q_STRING}         { /* include this file */
                              global_state * const state = yyget_extra(yyscanner);

                              char * filename = (char *)mem_sys_allocate_zeroed((yyleng - 2 + 1)
                                                                                * sizeof (char));
                              char * fullpath;

                              strncpy(filename, yytext + 1, yyleng - 2);

                              /* fprintf(stderr, "locating runtime file: [%s]\n", filename); */
                              fullpath = Parrot_locate_runtime_file(state->interp, filename,
                                                                    PARROT_RUNTIME_FT_INCLUDE);

                              if (fullpath == NULL) { /*
                                  fprintf(stderr, "Please make sure you're running pirc from "
                                          "parrot root directory, not from compilers/pirc. "
                                          "This will be fixed later. Sorry!\n");
*/
                                  /* for now, just fall back to filename */
                                  fullpath = filename;
                              }

                              /* fprintf(stderr, "fullpath: [%s]\n", fullpath); */
                              /* make sure that any error messages that occur in the .included
                               * file will report the right line number and file name.
                               */
                              fprintf(state->outfile, ".line 1\n");
                              fprintf(state->outfile, ".file %s\n", yytext); /* is quoted */

                              process_heredocs(state->interp, fullpath, state->outfile);

                              /* restore the location information; we didn't count the "\n"
                               * yet that will come after the .include dir.; hence the + 1 now.
                               */
                              fprintf(state->outfile, ".line %d\n", yyget_lineno(yyscanner) + 1);
                              fprintf(state->outfile, ".file '%s'\n", state->filename);

                              if (filename != fullpath)
                                  mem_sys_free(filename); /* only free one of them if they're
                                                                 same pointer */
                              mem_sys_free(fullpath);
                            }

<INCLUDE>{EOL}              { /* after .include "foo.pir", go back to the state we were in */
                              yy_pop_state(yyscanner);
                            }

<INCLUDE>.                  { lex_error(yyscanner, "wrong scanner state\n"); }

<INITIAL>.                  { fprintf(yyget_extra(yyscanner)->outfile, "%s", yytext); }

%%


/*
 * Local variables:
 *   c-file-style: "parrot"
 * End:
 * vim: expandtab shiftwidth=4:
 */

