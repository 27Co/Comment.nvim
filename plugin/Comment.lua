-- string pattern matching
-- characters:
-- . any character
-- %s whitespace
-- %d digit
-- %a letter
-- anchors:
-- ^ beginning of line
-- $ end of line
-- modifiers:
-- * zero or more
-- + one or more
-- - zero or one

local function extension()
    local fileName=vim.api.nvim_buf_get_name(0)
    return fileName:match("^.+(%..+)$")
end

local function cmtStr(ext)
    if string.match(ext, "%.c.*") then
        return "// "
    elseif string.match(ext, "%.lua") then
        return "-- "
    else
        return ""
    end
end

local function comment()
  local ext=extension()
  if ext==nil then
    return
  end
  local cmt=cmtStr(ext)
  local l=cmt:len()

  -- get_cursor: top right corner is (1, 0)
  local r=vim.api.nvim_win_get_cursor(0)[1]
  local line=vim.api.nvim_buf_get_lines(0, r-1, r, false)[1]
  local i=#(line:match("^%s*"))
  if line:sub(i, i+l)==cmt then
    vim.api.nvim_buf_set_text(0, r-1, i, r-1, i+l, {""})
  else
    vim.api.nvim_buf_set_text(0, r-1, i, r-1, i, {cmt})
  end
end

vim.keymap.set('n', '<M-,>', comment, {noremap = true})
