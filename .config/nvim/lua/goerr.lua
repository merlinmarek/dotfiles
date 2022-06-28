local ts_locals = require "nvim-treesitter.locals"
local ts_utils = require "nvim-treesitter.ts_utils"
local get_node_text = function(node) return vim.treesitter.get_node_text(node, 0) end

local function get_return_types(node)
  local scope = ts_locals.get_scope_tree(node, 0)
  for _, v in ipairs(scope) do
    if (v:type() == "function_declaration" or
        v:type() == "method_declaration" or
        v:type() == "func_literal") then
      local types_node = v:named_child(v:named_child_count() - 2)
      local return_types = {}
      if types_node:type() == "parameter_list" then
        for i = 0, types_node:named_child_count() - 1 do
          table.insert(return_types, get_node_text(types_node:named_child(i)))
        end
      elseif "type_identifier" then
        table.insert(return_types, get_node_text(types_node))
      else
        error("unhandled return node type" .. types_node:type())
      end
      return return_types
    end
  end
end

-- guesses the zero value from a type name
-- type aliases for basic types and interfaces that do not end with "err" will fail
-- TODO resolve types with the language server
local function guess_zero_value(type)
  local string_has_prefix = function(str, prefix) return str:sub(1, #prefix) == prefix end
  local string_has_suffix = function(str, suffix) return suffix == "" or str:sub(- #suffix) == suffix end

  if type == "int" then
    return "0"
  elseif type == "string" then
    return '""'
  elseif type == "bool" then
    return "false"
  elseif (type == "error" or
      string_has_prefix(type, "*") or
      string_has_prefix(type, "[]") or
      string_has_suffix(type, "er")) then
    return "nil"
  else
    return type .. "{}"
  end
end

function go_insert_err()
  local cursor_node = ts_utils.get_node_at_cursor()
  local return_types = get_return_types(cursor_node)
  if #return_types == 0 then
    print("return")
  else
    local return_string = "return "
    for i = 1, #return_types - 1 do
      return_string = return_string .. guess_zero_value(return_types[i]) .. ", "
    end
    return_string = return_string .. 'fmt.Errorf(": %w", err)'
    local cursor_position = vim.api.nvim_win_get_cursor(0)
    local prefix = string.match(vim.api.nvim_get_current_line(), "^\t*")
    vim.api.nvim_buf_set_lines(0, cursor_position[1], cursor_position[1], true, {
      prefix .. "if err != nil {",
      prefix .. "\t" .. return_string,
      prefix .. "}",
      prefix,
    })
    cursor_position[1] = cursor_position[1] + 2
    cursor_position[2] = #prefix + #return_string - 10
    vim.api.nvim_win_set_cursor(0, cursor_position)
    vim.cmd("startinsert")
  end
end
