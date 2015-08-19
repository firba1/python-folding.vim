func! Python_folding(lnum)
python << EOF
import vim
import re

lnum = int(vim.eval('a:lnum'))

current_line = vim.eval('getline({0})'.format(lnum))
previous_line = vim.eval('getline({0})'.format(lnum-1))
previous2_line = vim.eval('getline({0})'.format(lnum-2))
next_line = vim.eval('getline({0})'.format(lnum+1))
next2_line = vim.eval('getline({0})'.format(lnum+2))

fold = '='
import_re = re.compile('^\\b(import|from)\\b')
blank_re = re.compile('^\\s*$')
class_re = re.compile('^\\bclass\\b')
func_re = re.compile('^\\bdef\\b')
method_re = re.compile('^\\s+\\bdef\\b')
decorator_re = re.compile('@')
if (
    import_re.search(current_line) and
    not import_re.search(previous_line) and
    not import_re.search(previous2_line)
):
    fold = '>1'
elif (
    import_re.search(current_line) and
    not import_re.search(next_line) and
    not import_re.search(next2_line)
):
    fold = '<1'
elif (
    not blank_re.search(current_line) and
    blank_re.search(next_line) and
    blank_re.search(next2_line)
):
    fold = '<1'
elif class_re.search(current_line):
    fold = '>1'
elif func_re.search(current_line):
    fold = '>1'
elif (
    method_re.search(current_line) and
    not decorator_re.search(previous_line)
):
    print current_line
    fold = '>2'
elif (
    decorator_re.search(current_line) and
    not decorator_re.search(previous_line)
):
    fold = '>2'

vim.command("let foldval = '{0}'".format(fold))
EOF
return foldval
endfunc

setlocal foldexpr=Python_folding(v:lnum)
setlocal foldmethod=expr
setlocal foldcolumn=3
