###
Caleb Eggensperger
###

rules = ([sub, String.fromCharCode(0xE000 + index)] for sub, index in [
  '=='  # Comparison operators
  '!='
  '<='
  '>='
  '<<'  # Bit shifts
  '>>'
  '&&'  # Boolean operators
  '||'
  '->'  # C++ pointer calls
  '\\b' # Escape sequences
  '\\t'
  '\\n'
  '\\ '
  '\\"'
  "\\'"
  '\\\\'
  '/*'  # Comment delimiters
  '*/'
  '//'
  '"""' # Heredoc & heregex
  "'''"
  '///'
  '()'  # Empty groupers
  '[]'
  '{}'
  '<'
  '>'
  '!'
  '0x'
  '::'
  '='
])

regex_rules = [
  # Curly quotes
  [/"(.*?)"/g, '\u201C$1\u201D']
  [///
    (^|\W|\b[ru]) # Before the string. r/u is for python.
    '(.*?)'       # The string and the quotes.
    ($|\W)        # After the string.
   ///g, '$1\u2018$2\u2019$3']

  # Change angle brackets back to < and > in some cases
  [/\uE019\s/g, '< ']
  [/\s\uE01A/g, ' >']

  # Subscripts
  [/\b([a-zA-Z]\w*?)([0-9]+)\b/g,
    (_, varname, num) ->
      varname + (for digit in num.split ''
        String.fromCharCode(parseInt(digit) + 0x2080)).join('')]

  # Change negation back to exlamation mark in some cases
  [/[\w#]\ue01b/g, '$1' + '!']

  # Cleanup
  [/&/g, '&amp;']
  [/</g, '&lt;']
  [/>/g, '&gt;']
  [`/ /g`, '&nbsp;']
  [/\n/g, '<br />']
]

gel = (id) -> document.getElementById id

main = ->
  setTimeout update, 100 # Required for web fonts
  setInterval blink, 500

blink = ->
  cursor = gel 'cursor'
  return if not cursor?
  if cursor.style.background == 'black'
    cursor.style.background = 'white'
  else
    cursor.style.background = 'black'

update = ->
  input = gel 'input'
  code = input.value
  start = input.selectionStart
  end = input.selectionEnd
  parts = [code.substring(0, start),
           code.substring(start, end),
           code.substring(end, code.length)]
  for part, idx in parts
    new_part = []
    i = 0
    while i < part.length
      substrs = (part.substr(i, x) for x in [1..3])
      maybe_find = null
      for rule in rules
        [find, repl] = rule
        continue if find == null
        if find in substrs and
            (maybe_find == null or
            find.length > maybe_find.length)
          [maybe_find, maybe_repl] = rule
      if maybe_find?
        new_part.push(maybe_repl)
        i += maybe_find.length;
      else
        new_part.push(substrs[0])
        i++
    parts[idx] = new_part.join('')
    for rule in regex_rules
      parts[idx] = parts[idx].replace rule...
  code =
    parts[0] +
    (if focused then '<span id="highlight">' else '') +
      parts[1] + 
    (if focused then '</span><span id="cursor"></span>' else '') +
    parts[2]
  gel('display').innerHTML = code

window.main = main
window.update = update
window.focused = false
