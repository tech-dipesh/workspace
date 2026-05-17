# Neovim Cheatsheet — YouTuber Pro Edition
> Open with `<leader>?`  |  Windows 11 + JS/TS + C++ + Git/GitHub

---

## YOUR ORIGINAL SHORTCUTS (unchanged)

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal (Git Bash) |
| `<leader>t` | Toggle terminal |
| `<Esc><Esc>` | Exit terminal → normal mode |
| `<C-h/j/k/l>` | Navigate splits (works from terminal too) |
| `<C-d>` / `<C-u>` | Scroll down/up (cursor centered) |
| `n` / `N` | Next/prev search (centered) |
| `J` / `K` (visual) | Move selection down/up |
| `<C-s>` | Save file |
| `<leader>p` (visual) | Paste without overwriting clipboard |
| `<leader>d` | Delete without yanking |
| `<Tab>` / `<S-Tab>` | Next/prev buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>R` | Reload config |
| `<leader>uk` | Toggle Screenkey |
| `<leader>h` | Open dashboard |
| `<leader>n` | Create new file |
| `<leader>fD` | Delete current file |
| `<C-a>` | Select all |
| `Q` | Replay macro @q |
| `<` / `>` (visual) | Indent left/right (keep selection) |

---

## MULTIPLE TERMINALS

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle main terminal |
| `<leader>t1` to `<leader>t5` | Open terminal #1 through #5 |
| `<Esc><Esc>` | Exit to normal mode |
| `<C-h/j/k/l>` | Move from terminal to any split |

Terminal title shows (no clock): `#1  myproject   main +2 ~1  2 errors`
= terminal number | project | git branch | staged/modified | diagnostics

---

## C++ COMPILE & RUN (Windows spaces-in-path FIXED)

| Key | Action |
|-----|--------|
| `<leader>rr` | Compile & run (ANY path, even with spaces) |
| `<leader>ri` | Compile & run with `input.txt` stdin (CP) |
| `<leader>rb` | Compile only — see errors |
| `<leader>rI` | Edit `input.txt` for test cases |
| `<leader>cs` | Switch `.h` ↔ `.cpp` |
| `<leader>ci` | Clangd symbol info |
| `<F5>` | Start/continue debugger |
| `<F9>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dq` | Stop debugger |

---

## MARKDOWN PREVIEW

| Key | Action |
|-----|--------|
| `<leader>mp` | Open `.md` in browser (live preview) |
| `<leader>ms` | Stop browser preview |
| `<leader>mr` | Toggle inline rendering inside Neovim |

---

## AUTO-SAVE (instant, silent)

Saves on: every text change, `<Esc>`, 150ms idle, window focus loss.
Never interrupts — completely silent. Toggle format: `<leader>uf`

---

## MOVEMENT

| Key | Action |
|-----|--------|
| `H` | Start of line (first non-blank) |
| `L` | End of line (last non-blank) |
| `<A-j>` / `<A-k>` | Move line up/down (normal + insert) |
| `s` | Flash jump (2 chars + label) |
| `S` | Flash treesitter node jump |
| `]f` / `[f` | Next/prev function |
| `]c` / `[c` | Next/prev class |
| `<C-space>` | Expand treesitter selection |
| `<bs>` | Shrink treesitter selection |

---

## EDITING

| Key | Action |
|-----|--------|
| `J` (normal) | Join line (cursor stays in place) |
| `<leader>yl` | Duplicate line / selection |
| `<leader>o` / `O` | Blank line below/above (stay normal) |
| `<A-;>` | Append `;` at end of line |
| `<A-,>` | Append `,` at end of line |
| `gS` | Split/join function args |
| `Q` (visual) | Run macro @q on every selected line |
| `<leader>rs` | Replace word under cursor in file |

---

## WINDOWS & BUFFERS

| Key | Action |
|-----|--------|
| `<C-arrow>` | Resize split |
| `<leader>wv` / `ws` | Vertical / horizontal split |
| `<leader>we` | Equalize splits |
| `<leader>wx` | Close split |
| `<leader>wm` | Toggle maximize split |
| `<A-1>` to `<A-9>` | Jump to buffer by number |
| `<leader>bn` | New buffer |
| `<leader>bp` | Pin/unpin buffer |
| `<leader><tab>n/d/]/[` | New/close/next/prev tab |

---

## FILE EXPLORER (neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle explorer |
| `<leader>E` | Reveal current file |
| `l` / `<CR>` | Open / expand |
| `h` | Collapse folder |
| `H` | Toggle node_modules |
| `Y` | Copy path |
| `P` | Floating preview |
| `i` | File details + hidden count |
| `<C-v>` / `<C-x>` | Open in vsplit / split |
| `a` / `d` / `r` | New / Delete / Rename |

Shown by default: `.env`, `.gitignore`, `.dockerignore`, `.vscode`, `.eslintrc`, `.prettierrc`
Never shown: `.git`

---

## TELESCOPE

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (project root) |
| `<leader>fg` | Live grep (project root) |
| `<leader>fw` | Grep word under cursor |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>fs` | Search in current file |
| `<leader>fk` | Find keymaps |
| `<leader>ft` | Find TODOs |

---

## HARPOON

| Key | Action |
|-----|--------|
| `<leader>ha` | Add file |
| `<leader>hh` | Menu |
| `<leader>1-4` | Jump to slot 1-4 |
| `<leader>hp` / `hn` | Prev / next |

---

## LSP

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `gr` | References |
| `K` | Hover docs |
| `gK` | Signature help |
| `<leader>ca` | Code actions |
| `<leader>cR` | Rename |
| `<leader>cf` | Format |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev error |

---

## TYPESCRIPT

| Key | Action |
|-----|--------|
| `<leader>tl` | Insert console.log for word |
| `<leader>tL` | Remove all console.logs |
| `<A-;>` | Append `;` |
| `<A-,>` | Append `,` |

---

## NPM (in package.json)

| Key | Action |
|-----|--------|
| `<leader>ns` | Show versions |
| `<leader>nu` | Update package |
| `<leader>ni` | Install package |

---

## GIT (gitsigns)

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghd` | Diff vs HEAD |
| `<leader>ghb` | Full blame |
| `<leader>gtb` | Toggle inline blame |

---

## GIT UI

| Key | Action |
|-----|--------|
| `<leader>gg` | Neogit (full TUI) |
| `<leader>gG` | LazyGit |
| `<leader>gC` | Commit |
| `<leader>gP` | Push |
| `<leader>gF` | Pull |
| `<leader>gd` | Diff view |
| `<leader>gf` | File history |
| `<leader>gl` | Git log |
| `<leader>gb` | Branches |
| `<leader>gs` | Status |
| `<leader>gB` | Open on GitHub |
| `<leader>gwl` | Worktrees list/switch |
| `<leader>gwc` | Create worktree |

---

## GITHUB PRs (Octo) — needs `gh auth login`

| Key | Action |
|-----|--------|
| `<leader>Gpl` | List PRs |
| `<leader>Gpc` | Create PR |
| `<leader>Gpm` | Merge PR (squash) |
| `<leader>Gpa` | Add reviewer |
| `<leader>Grv` | Start review |
| `<leader>GrS` | Submit review |
| `<leader>Gil` | List issues |
| `<leader>Gic` | Create issue |

---

## DIAGNOSTICS

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics |
| `<leader>xd` | Buffer diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xt` | TODOs |
| `]t` / `[t` | Next/prev TODO |

---

## MARKDOWN

| Key | Action |
|-----|--------|
| `<leader>mp` | Browser preview |
| `<leader>mr` | Inline render toggle |

---

## LIVE SERVER

| Key | Action |
|-----|--------|
| `<F5>` | Start (port 8000) |
| `<F6>` | Stop |
| `<F7>` | Open browser |

---

## UTILITIES

| Key | Action |
|-----|--------|
| `<leader>L` | Lazy |
| `<leader>M` | Mason |
| `<leader>uu` | Undo tree |
| `<leader>wc` | Word count |
| `<leader>cE` | Open in Windows Explorer |
| `<leader>?` | This cheatsheet |
