local expr={}

local function number(expression)
  local number_str = ""

  while expression["pos"] <= string.len(expression["expr"]) do
    local token = string.sub(expression["expr"], expression["pos"], expression["pos"])
    if string.find(token, "%d") then
      number_str = number_str .. token
    else
      break
    end
    expression["pos"] = expression["pos"] + 1
  end
  print(number_str)
  return tonumber(number_str)
end

local function factor(expr)
  local result = 0

  local token = string.sub(expr["expr"], expr["pos"], expr["pos"])
  if string.find(token, "%(") then
    expr["pos"] = expr["pos"] + 1
    result = expr_analysis(expr["expr"], expr["pos"])
    print("rel")
    print(result)
    print(expr["pos"])
    local token2 = string.sub(expr["expr"], expr["pos"], expr["pos"])
    if string.find(token2, "%)") then
      expr["pos"] = expr["pos"] + 1
    end
    return result
  end
  return number(expr)
end

local function term(expr)
  local x = factor(expr)
  while true do
    local token = string.sub(expr["expr"], expr["pos"], expr["pos"])
    if string.find(token, "%*") then
      expr["pos"] = expr["pos"] + 1
      x = x * factor(expr)
    elseif string.find(token, "%/") then
      expr["pos"] = expr["pos"] + 1
      x = x / factor(expr)
    else
      break
    end
  end
  return x
end

function expr_analysis(expression, pos)
  expr["expr"]=expression
  if pos == nil then
    expr["pos"]=1
  else
    expr["pos"]=pos
  end

  local x = term(expr)
  while true do
    local token = string.sub(expr["expr"], expr["pos"], expr["pos"])
    if string.find(token, "+") then
      expr["pos"] = expr["pos"] + 1
      x = x + term(expr)
    elseif string.find(token, "-") then
      expr["pos"] = expr["pos"] + 1
      x = x - term(expr)
    else
      break
    end
  end
  return x
end

local expression = io.read()
print(expression .. "=" .. expr_analysis(expression))
