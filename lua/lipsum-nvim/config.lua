local gen = require("lipsum-nvim.generate")
local util = require("lipsum-nvim.util")

local M = {}

M.namespace = vim.api.nvim_create_namespace("Lipsum")

---@class lipsum-nvim.Options
local defaults = {
  ---@type string[] List of words used for generation, will be merged with lipsum-nvim.Options.word_list
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
}

---@type lipsum-nvim.Options
M.options = {}

---Plugin init
---@param options? lipsum-nvim.Options
function M.setup(options)
  if vim.fn.has("nvim-0.10") == 0 then
    util.err("Requires neovim 0.10+, probably.")
  end
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

  if M.options.word_list ~= nil then
    local ok, wl = pcall(require, "lipsum-nvim.words." .. string.lower(M.options.word_list))
    if not ok or wl == nil then
      util.err("Failed to import wordlist: " .. M.options.word_list)
    end
    M.options.words = vim.tbl_deep_extend("force", {}, M.options.words, wl)
  end

  if M.options.user_commands.words ~= nil then
    vim.api.nvim_create_user_command(M.options.user_commands.words, function(opts)
      util.insert_text(M.words(tonumber(opts.args or "1")))
    end, {
      nargs = "?",
      desc = "[lipsum-nvim] Generate word(s)",
    })
  end

  if M.options.user_commands.lines ~= nil then
    vim.api.nvim_create_user_command(M.options.user_commands.lines, function(opts)
      util.insert_text(M.lines(tonumber(opts.args or "1")))
    end, {
      nargs = "?",
      desc = "[lipsum-nvim] Generate line(s)",
    })
  end

  if M.options.user_commands.paragraphs ~= nil then
    vim.api.nvim_create_user_command(M.options.user_commands.paragraphs, function(opts)
      util.insert_text(M.paragraphs(tonumber(opts.args or "1")))
    end, {
      nargs = "?",
      desc = "[lipsum-nvim] Generate paragraph(s)",
    })
  end
end

---Generate one or more random words
---@param count? number Number of words to generate
---@return string
function M.words(count)
  return gen.words(M.options.words, M.options.comma_chance, M.options.semicolon_chance, count or 1)
end

---Generate one or more lines/sentences or random length
---@param count? number Number of lines to generate
---@return string
function M.lines(count)
  return gen.lines(
    M.options.words,
    M.options.comma_chance,
    M.options.semicolon_chance,
    M.options.line_len[1],
    M.options.line_len[2],
    count or 1
  )
end

---Generate one or more paragraphs of random length
---@param count? number Number of paragraphs to generate
---@return string
function M.paragraphs(count)
  return gen.paragraphs(
    M.options.words,
    M.options.comma_chance,
    M.options.semicolon_chance,
    M.options.line_len[1],
    M.options.line_len[2],
    M.options.paragraph_len[1],
    M.options.paragraph_len[2],
    count or 1
  )
end

return M
