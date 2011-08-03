set ambiwidth=double
set conceallevel=1

let s:subs = ['₀', 'ₐ', 'ₑ', 'ₒ', 'ₓ', '₅', '₆', '₇', '₈', '₉']
for i in range(10)
  exe 'syntax match pseudocode /\<\a\w*' . i . '/ms=e conceal cchar=' . s:subs[i]
endfor
unlet s:subs
syntax match Pseudocode /^!\|[^a-zA-Z0-9#]\@=!/ conceal cchar=¬
syntax match Pseudocode /=/ conceal cchar=⇐
syntax match Pseudocode /< \@!/ conceal cchar=⟨
syntax match Pseudocode / \@!>/ conceal cchar=⟩
" syntax match Pseudocode /"\z([^"]*"\)/ conceal cchar=s"„
" syntax match Pseudocode /\z("[^"]*\)"/ conceal cchar=e"‟
syntax region PseudocodeString matchgroup=Quote start=/"/ concealends cchar=s skip=/\\"/ end=/"/ concealends cchar=e"‟
syntax match Pseudocode /'/ conceal cchar=‚
syntax match Pseudocode /'\([^']*'\)\@=/ conceal cchar=‛
syntax match Pseudocode /==/   conceal cchar=
syntax match Pseudocode /!=/   conceal cchar=
syntax match Pseudocode /<=/   conceal cchar=
syntax match Pseudocode />=/   conceal cchar=
syntax match Pseudocode /<</   conceal cchar=
syntax match Pseudocode />>/   conceal cchar=
syntax match Pseudocode /&&/   conceal cchar=
syntax match Pseudocode /||/   conceal cchar=
syntax match Pseudocode /->/   conceal cchar=
syntax match Pseudocode /\\b/  conceal cchar=
syntax match Pseudocode /\\t/  conceal cchar=
syntax match Pseudocode /\\n/  conceal cchar=
syntax match Pseudocode /\\ /  conceal cchar=
syntax match Pseudocode /\\"/  conceal cchar=
syntax match Pseudocode /\\'/  conceal cchar=
syntax match Pseudocode /\\\\/ conceal cchar=
syntax match Pseudocode =/\*=  conceal cchar=
syntax match Pseudocode =\*/=  conceal cchar=
syntax match Pseudocode =//=   conceal cchar=
syntax match Pseudocode /()/   conceal cchar=
syntax match Pseudocode /\[\]/ conceal cchar=
syntax match Pseudocode /{}/   conceal cchar=
syntax match Pseudocode /0x/   conceal cchar=
syntax match Pseudocode /\:\:/ conceal cchar=

hi! link Conceal Plain

