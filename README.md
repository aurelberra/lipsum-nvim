# lipsum-nvim

A (more or less) simple `Lorem Ipsum` generation plugin.

Originally created by `Stewie410`, whose repo is no longer available.

## ✨ Features

- User-defined wordlists for generation
- Generate 1+ words, lines/sentences or paragraphs
- Customize generator command names

## ⚠️ Requirements

- Neovim version 0.10.0 or higher
  - Only tested on v0.10, _may_ work on older versions

## 📦 Installation

### 💤 lazy.nvim

```lua
{
    "aurelberra/lipsum-nvim",
    cmd = {
        "LipsumWord",
        "LipsumLine",
        "LipsumParagraph",
    },
    opts = {},
}
```

### 🚐 mini.deps

```lua
local deps = require("mini.deps")
deps.add({
    source = "aurelberra/lipsum-nvim",
})
```

## 📝 Configuration

```lua
require("lipsum-nvim").setup({
  ---@type string[] List of words used for generation, will be merged with lipsum.Options.word_list
  words = {},
  ---@type 'cicero'|'english'|'lipsum'|'standard'|nil Preset word list
  word_list = "standard",
  ---@type decimal Chance to insert a comma after a word
  comma_chance = 0.2,
  ---@type decimal Chance to insert a semicolon after a word
  semicolon_chance = 0.05,
  ---@type number[] Min/Max number of words per line
  line_len = { 5, 12 },
  ---@type number[] Min/Max number of lines per paragraph
  paragraph_len = { 5, 20 },
  ---@type table<string, string|nil> Create generation commands, set to nil to disable the command
  user_commands = {
    ---@type string|nil Command to generate word(s), set to nil to disable
    words = "LipsumWord",
    ---@type string|nil Command to generate line(s), set to nil to disable
    lines = "LipsumLine",
    ---@type string|nil Command to generate paragraph(s), set to nil to disable
    paragraphs = "LipsumParagraph",
  },
})
```

## ⌨️ Commands

Command names can be customized in the setup options; but by default:

- `LipsumWord [num]`: Generate random word(s) from word list
- `LipsumLine [num]`: Generate random line(s)/sentence(s) from word list
- `LipsumParagraph [num]`: Generate random paragraph(s) from word list

Each command will _always_ generate at least 1 item.

## Word Generation

Words generated with [lipsum.com](https://www.lipsum.com), based on the
following options:

- 100,000 words
- Start with “Lorem ipsum dolor sit amet” enabled

Once produced, filtered the results with some `shellscript`:

```bash
tr -d '\n[:punct:]' < lorem.txt | \
    tr '[:upper:] ' '[:lower:]\n' | \
    awk '!seen[$0]++ { printf "\t\"%s\",\n", $1 }' | \
    sort
```

While this may not produce every possible word from the generator, on average
this produces around 300 unique words, which should be sufficient, hopefully.

To add your own custom words:

```bash
require("lipsum-nvim").setup({
    words = {
        -- words
    },
})
```

## Links

- [`derktata/lorem.nvim`](https://github.com/derektata/lorem.nvim)
- [`mbpowers/lorem-nvim`](https://github.com/mbpowers/lorem-nvim)
- [`lipsum.com`](https://www.lipsum.com/)
