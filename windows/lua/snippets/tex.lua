-- ==============================================================================
-- LATEX SNIPPETS (LuaSnip implementation of Gilles Castel's setup)
-- ==============================================================================

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local tex_utils = require("snippets.tex_utils")
local in_mathzone = tex_utils.in_mathzone
local line_begin = tex_utils.line_begin
local get_visual = tex_utils.get_visual

return {
  -- ============================================================================
  -- 1. DOCUMENT STRUCTURE & ENVIRONMENTS
  -- ============================================================================

  -- Template
  s({ trig = "template", condition = line_begin },
    fmta([[\documentclass{article}
\input{preamble}

\title{<>}
\author{Lorenzo Zambardi}
\date{A.A. <>}

\begin{document}

\maketitle

\pagebreak

<>

\end{document}]], { i(1), i(2), i(0) })
  ),

  -- Begin / End
  s({ trig = "beg", snippetType = "autosnippet", condition = line_begin },
    fmta([[\begin{<>}
	<>
\end{<>}]], { i(1), i(0), rep(1) })
  ),

  -- Table
  s({ trig = "table", condition = line_begin },
    fmta([[\begin{table}[<>]
	\centering
	\caption{<>}
	\label{tab:<>}
	\begin{tabular}{<>}
	<>
	\end{tabular}
\end{table}]], {
      i(1, "htpb"),
      i(2, "caption"),
      i(3, "label"),
      i(4, "c"),
      i(0),
    })
  ),

  -- Figure
  s({ trig = "fig", condition = line_begin },
    fmta([[\begin{figure}[<>]
	\centering
	<>
	\caption{<>}
	\label{fig:<>}
\end{figure}]], {
      i(1, "htpb"),
      d(2, function(args)
        return sn(nil, fmta([[\includegraphics[width=0.8\textwidth]{<>}]], { i(1, args[1][1]) }))
      end, { 3 }),
      i(3, "caption"),
      f(function(args)
        return (args[1][1] or ""):lower():gsub("%W+", "-")
      end, { 3 }),
    })
  ),

  -- Enumerate
  s({ trig = "enum", snippetType = "autosnippet", condition = line_begin },
    fmta([[\begin{enumerate}
	\item <>
\end{enumerate}]], { i(0) })
  ),

  -- Itemize
  s({ trig = "item", snippetType = "autosnippet", condition = line_begin },
    fmta([[\begin{itemize}
	\item <>
\end{itemize}]], { i(0) })
  ),

  -- Description
  s({ trig = "desc", condition = line_begin },
    fmta([[\begin{description}
	\item[<>] <>
\end{description}]], { i(1), i(0) })
  ),

  -- Package
  s({ trig = "pac", condition = line_begin },
    fmta([[\usepackage[<>]{<>}<>]], { i(1, "options"), i(2, "package"), i(0) })
  ),

  -- Align*
  s({ trig = "ali", snippetType = "autosnippet", condition = line_begin },
    fmta([[\begin{align*}
	<>
\end{align*}]], { d(1, get_visual) })
  ),

  -- Cases
  s({ trig = "case", snippetType = "autosnippet", wordTrig = true },
    fmta([[\begin{cases}
	<>
\end{cases}]], { i(1) })
  ),

  -- Big function
  s({ trig = "bigfun", snippetType = "autosnippet", wordTrig = false },
    fmta([[\begin{align*}
	<>: <> &\longrightarrow <> \\
	<> &\longmapsto <>(<>) = <>
\end{align*}]], { i(1), i(2), i(3), i(4), rep(1), rep(4), i(0) })
  ),

  -- SI Units
  s({ trig = "SI", snippetType = "autosnippet", wordTrig = false },
    fmta([[\SI{<>}{<>}]], { i(1), i(2) })
  ),

  -- Let Omega
  s({ trig = "letw", snippetType = "autosnippet", wordTrig = false },
    t("Let $\\Omega \\subset \\mathbb{C}$ be open.")
  ),

  -- ============================================================================
  -- 2. INLINE & DISPLAY MATH DELIMITERS
  -- ============================================================================

  -- Inline Math (mk)
  s({ trig = "mk", snippetType = "autosnippet", wordTrig = true },
    fmta("$<>$<>", { i(1), i(0) })
  ),

  -- Display Math (dm)
  s({ trig = "dm", snippetType = "autosnippet", wordTrig = true },
    fmta([[<>
<>
<><>]], {
      f(function() return vim.bo.filetype == "markdown" and "$$" or "\\[" end),
      d(1, get_visual),
      f(function() return vim.bo.filetype == "markdown" and "$$" or "\\]" end),
      i(0),
    })
  ),

  -- ... ldots
  s({ trig = "...", snippetType = "autosnippet", wordTrig = false, priority = 100 },
    t("\\ldots")
  ),

  -- ============================================================================
  -- 3. FRACTIONS & OPERATORS
  -- ============================================================================

  -- Fraction //
  s({ trig = "//", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) })
  ),

  -- Regex symbol fraction: 7/ -> \frac{7}{} or \alpha/ -> \frac{\alpha}{} or x^2/ -> \frac{x^2}{}
  s({ trig = [[((%d+)|(%d*)([\\]?)([A-Za-z]+)(([%^_])({%d+}|%d))*)/]], regTrig = true, snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\frac{<>}{<>}<>]], {
      f(function(_, snip) return snip.captures[1] end),
      i(1),
      i(0),
    })
  ),

  -- Regex paren fraction: (1 + 2 + 3)/ -> \frac{1 + 2 + 3}{}
  s({ trig = ".*%)%/", regTrig = true, snippetType = "autosnippet", wordTrig = false, priority = 1000, condition = in_mathzone },
    fmta([[<>{<>}<>]], {
      f(function(_, snip)
        local stripped = snip.trigger:sub(1, -2)
        local depth = 0
        local idx = #stripped
        while idx > 0 do
          local c = stripped:sub(idx, idx)
          if c == ")" then depth = depth + 1
          elseif c == "(" then depth = depth - 1 end
          if depth == 0 then break end
          idx = idx - 1
        end
        return stripped:sub(1, idx - 1) .. "\\frac{" .. stripped:sub(idx + 1, -2) .. "}"
      end),
      i(1),
      i(0),
    })
  ),

  -- Partial derivative
  s({ trig = "part", wordTrig = true, condition = in_mathzone },
    fmta([[\frac{\partial <>}{\partial <>} <>]], { i(1, "V"), i(2, "x"), i(0) })
  ),

  -- Square root
  s({ trig = "sqrt", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\sqrt{<>} <>]], { d(1, get_visual), i(0) })
  ),

  -- Integral
  s({ trig = "int", snippetType = "autosnippet", wordTrig = true, condition = in_mathzone },
    fmta([[\int_{<>}^{<>} <> <>]], { i(1, "-\\infty"), i(2, "\\infty"), d(3, get_visual), i(0) })
  ),

  -- Sum
  s({ trig = "sum", wordTrig = true, condition = in_mathzone },
    fmta([[\sum_{n=<>}^{<>} <>]], { i(1, "1"), i(2, "\\infty"), i(3, "a_n z^n") })
  ),

  -- Taylor series
  s({ trig = "taylor", wordTrig = true, condition = in_mathzone },
    fmta([[\sum_{<>=<>}^{<>} <> (x-a)^<> <>]], { i(1, "k"), i(2, "0"), i(3, "\\infty"), i(4, "c_" .. 1), rep(1), i(0) })
  ),

  -- Limit
  s({ trig = "lim", wordTrig = true, condition = in_mathzone },
    fmta([[\lim_{<> \to <>} ]], { i(1, "n"), i(2, "\\infty") })
  ),

  -- Limsup
  s({ trig = "limsup", wordTrig = true, condition = in_mathzone },
    fmta([[\limsup_{<> \to <>} ]], { i(1, "n"), i(2, "\\infty") })
  ),

  -- Product
  s({ trig = "prod", wordTrig = true, condition = in_mathzone },
    fmta([[\prod_{<>}^{<>} <> <>]], {
      d(1, function(args) return sn(nil, fmta("n=<>", { i(1, "1") })) end),
      i(2, "\\infty"),
      d(3, get_visual),
      i(0),
    })
  ),

  -- ============================================================================
  -- 4. MATRICES & DELIMITERS
  -- ============================================================================

  -- pmat
  s({ trig = "pmat", snippetType = "autosnippet", wordTrig = false },
    fmta([[\begin{pmatrix} <> \end{pmatrix} <>]], { i(1), i(0) })
  ),

  -- bmat
  s({ trig = "bmat", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\begin{bmatrix} <> \end{bmatrix} <>]], { i(1), i(0) })
  ),

  -- cvec
  s({ trig = "cvec", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\begin{pmatrix} <>_<>\\ \vdots\\ <>_<> \end{pmatrix}]], { i(1, "x"), i(2, "1"), rep(1), i(3, "n") })
  ),

  -- Parentheses ()
  s({ trig = "()", wordTrig = false, condition = in_mathzone },
    fmta([[\left( <> \right) <>]], { d(1, get_visual), i(0) })
  ),

  -- Norm ||
  s({ trig = "||", wordTrig = false, condition = in_mathzone },
    fmta([[\left| <> \right| <>]], { d(1, get_visual), i(0) })
  ),

  -- Curly braces {}
  s({ trig = "{}", wordTrig = false, condition = in_mathzone },
    fmta([[\left\{ <> \right\} <>]], { d(1, get_visual), i(0) })
  ),

  -- Square brackets []
  s({ trig = "[]", wordTrig = false, condition = in_mathzone },
    fmta([[\left[ <> \right] <>]], { d(1, get_visual), i(0) })
  ),

  -- Angle brackets lra
  s({ trig = "lra", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\left\langle <>\right\rangle<>]], { d(1, get_visual), i(0) })
  ),

  -- Ceil
  s({ trig = "ceil", snippetType = "autosnippet", wordTrig = false },
    fmta([[\left\lceil <> \right\rceil <>]], { i(1), i(0) })
  ),

  -- Floor
  s({ trig = "floor", snippetType = "autosnippet", wordTrig = false },
    fmta([[\left\lfloor <> \right\rfloor<>]], { i(1), i(0) })
  ),

  -- Conjugate
  s({ trig = "conj", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\overline{<>}<>]], { i(1), i(0) })
  ),

  -- Norm
  s({ trig = "norm", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\|<>\|<>]], { i(1), i(0) })
  ),

  -- Mathcal
  s({ trig = "mcal", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\mathcal{<>}<>]], { i(1), i(0) })
  ),

  -- Textbf
  s({ trig = "bf", snippetType = "autosnippet", wordTrig = true, condition = in_mathzone },
    fmta([[\textbf{<>}<>]], { i(1), i(0) })
  ),

  -- Text inside math
  s({ trig = "txt", snippetType = "autosnippet", wordTrig = false },
    fmta([[\text{<>}<>]], { i(1), i(0) })
  ),

  -- Text subscript: sts
  s({ trig = "sts", snippetType = "autosnippet", wordTrig = false, condition = function(line_to_cursor, matched_trigger)
      if not in_mathzone() then return false end
      local prefix = line_to_cursor:sub(1, -(#matched_trigger + 1))
      return not prefix:match("i$")
    end },
    fmta([[_\text{<>} <>]], { i(1), i(0) })
  ),

  -- ============================================================================
  -- 5. POWERS, SUBSCRIPTS & VARIABLES
  -- ============================================================================

  -- ^2
  s({ trig = "sr", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    t("^2")
  ),

  -- ^3
  s({ trig = "cb", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    t("^3")
  ),

  -- ^{...}
  s({ trig = "td", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta("^{<>}<>", { i(1), i(0) })
  ),

  -- _{...}
  s({ trig = "__", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta("_{<>}<>", { i(1), i(0) })
  ),

  -- Auto subscript: x1 -> x_1
  s({ trig = "([A-Za-z])(%d)", regTrig = true, snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    f(function(_, snip) return snip.captures[1] .. "_" .. snip.captures[2] end)
  ),

  -- Auto subscript 2 digits: x_12 -> x_{12}
  s({ trig = "([A-Za-z])_(%d%d)", regTrig = true, snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    f(function(_, snip) return snip.captures[1] .. "_{" .. snip.captures[2] .. "}" end)
  ),

  -- Variables
  s({ trig = "xnn", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("x_{n}")),
  s({ trig = "ynn", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("y_{n}")),
  s({ trig = "xii", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("x_{i}")),
  s({ trig = "yii", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("y_{i}")),
  s({ trig = "xjj", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("x_{j}")),
  s({ trig = "yjj", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("y_{j}")),
  s({ trig = "xp1", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("x_{n+1}")),
  s({ trig = "xmm", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("x_{m}")),
  s({ trig = "R0+", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{R}_0^+")),

  -- Sequence (x_n)
  s({ trig = "rij", wordTrig = false, condition = in_mathzone },
    fmta([[(<>_<>)_{<>\in<>}<>]], { i(1, "x"), i(2, "n"), rep(2), i(3, "\\mathbb{N}"), i(0) })
  ),

  -- ============================================================================
  -- 6. SYMBOLS, RELATIONS & LOGIC
  -- ============================================================================

  s({ trig = "==", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta("&= <> \\\\", { i(1) })
  ),
  s({ trig = "!=", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\neq ")),
  s({ trig = "<=", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\le ")),
  s({ trig = ">=", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\ge ")),
  s({ trig = "=>", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\implies")),
  s({ trig = "=<", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\impliedby")),
  s({ trig = "iff", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\iff")),
  s({ trig = "->", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\to ")),
  s({ trig = "<->", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\leftrightarrow")),
  s({ trig = "!>", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mapsto ")),
  s({ trig = "invs", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("^{-1}")),
  s({ trig = "cmpl", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("^{c}")),
  s({ trig = "\\\\\\", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\setminus")),
  s({ trig = ">>", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\gg")),
  s({ trig = "<<", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\ll")),
  s({ trig = "~~", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\sim ")),
  s({ trig = "ooo", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\infty")),
  s({ trig = "lll", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\ell")),
  s({ trig = "nabl", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\nabla ")),
  s({ trig = "xx", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\times ")),
  s({ trig = "**", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\cdot ")),
  s({ trig = "eps", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\varepsilon")),
  s({ trig = "<!", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\triangleleft ")),
  s({ trig = "<>", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\diamond ")),

  -- Sets & Quantifiers
  s({ trig = "set", snippetType = "autosnippet", wordTrig = true, condition = in_mathzone },
    fmta([[\{<>\} <>]], { i(1), i(0) })
  ),
  s({ trig = "sbst", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\subset ")),
  s({ trig = "notin", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\not\\in ")),
  s({ trig = "inn", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\in ")),
  s({ trig = "Nn", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\cap ")),
  s({ trig = "UU", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\cup ")),
  s({ trig = "uuu", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\bigcup_{<>} <>]], { i(1, "i \\in I"), i(0) })
  ),
  s({ trig = "nnn", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone },
    fmta([[\bigcap_{<>} <>]], { i(1, "i \\in I"), i(0) })
  ),
  s({ trig = "OO", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\emptyset")),
  s({ trig = "NN", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{N}")),
  s({ trig = "RR", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{R}")),
  s({ trig = "QQ", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{Q}")),
  s({ trig = "ZZ", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{Z}")),
  s({ trig = "HH", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{H}")),
  s({ trig = "DD", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{D}")),
  s({ trig = "Ee", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{E}")),
  s({ trig = "EE", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\exists ")),
  s({ trig = "AA", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\forall ")),
  s({ trig = "PP", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone }, t("\\mathbb{P}")),

  -- ============================================================================
  -- 7. BAR, HAT & GREEK/TRIG FUNCTIONS
  -- ============================================================================

  -- bar / hat
  s({ trig = "bar", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone, priority = 10 },
    fmta([[\bar{<>}<>]], { i(1), i(0) })
  ),
  s({ trig = "([a-zA-Z])bar", regTrig = true, snippetType = "autosnippet", wordTrig = false, condition = in_mathzone, priority = 100 },
    f(function(_, snip) return "\\bar{" .. snip.captures[1] .. "}" end)
  ),
  s({ trig = "hat", snippetType = "autosnippet", wordTrig = false, condition = in_mathzone, priority = 10 },
    fmta([[\hat{<>}<>]], { i(1), i(0) })
  ),
  s({ trig = "([a-zA-Z])hat", regTrig = true, snippetType = "autosnippet", wordTrig = false, condition = in_mathzone, priority = 100 },
    f(function(_, snip) return "\\hat{" .. snip.captures[1] .. "}" end)
  ),

  -- Trig / Math functions
  s({ trig = "(%a+)", regTrig = true, snippetType = "autosnippet", wordTrig = false, priority = 100,
      condition = function(line_to_cursor, matched_trigger)
        if not in_mathzone() then return false end
        local words = { sin=1, cos=1, arccot=1, cot=1, csc=1, ln=1, log=1, exp=1, star=1, perp=1 }
        if not words[matched_trigger] then return false end
        local prefix = line_to_cursor:sub(1, -(#matched_trigger + 1))
        return not prefix:match("\\[%a]*$")
      end },
    f(function(_, snip) return "\\" .. snip.trigger end)
  ),

  -- Greek / Complex trig
  s({ trig = "(%a+)", regTrig = true, snippetType = "autosnippet", wordTrig = false, priority = 200,
      condition = function(line_to_cursor, matched_trigger)
        if not in_mathzone() then return false end
        local words = {
          arcsin=1, arccos=1, arctan=1, arccot=1, arccsc=1, arcsec=1,
          pi=1, zeta=1, to=1, delta=1, kappa=1, lambda=1, mu=1, nu=1,
          rho=1, sigma=1, tau=1, omega=1
        }
        if not words[matched_trigger] then return false end
        local prefix = line_to_cursor:sub(1, -(#matched_trigger + 1))
        return not prefix:match("\\[%a]*$")
      end },
    f(function(_, snip) return "\\" .. snip.trigger end)
  ),

  -- ============================================================================
  -- 8. SYMPY & WOLFRAM EVALUATION
  -- ============================================================================

  s({ trig = "sympy", wordTrig = true },
    fmta("sympy <> sympy<>", { i(1), i(0) })
  ),
  s({ trig = "sympy(.*)sympy", regTrig = true, priority = 10000 },
    f(function(_, snip)
      local code = snip.captures[1]
      local py_script = string.format([[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
expr = %s
print(latex(eval(expr)), end='')
]], vim.fn.json_encode(code:gsub("\\", ""):gsub("%^", "**"):gsub("{", "("):gsub("}", ")")))
      local res = vim.fn.system({ "python3", "-c", py_script })
      return vim.trim(res)
    end)
  ),

  s({ trig = "math", wordTrig = true, priority = 1000 },
    fmta("math <> math<>", { i(1), i(0) })
  ),
  s({ trig = "math(.*)math", regTrig = true, priority = 10000 },
    f(function(_, snip)
      local code = "ToString[" .. snip.captures[1] .. ", TeXForm]"
      local res = vim.fn.system({ "wolframscript", "-code", code })
      return vim.trim(res)
    end)
  ),

  -- ============================================================================
  -- 9. TIKZ & PLOTS
  -- ============================================================================

  -- Plot
  s({ trig = "plot", wordTrig = true },
    fmta([[\begin{center}
	\begin{tikzpicture}
		\begin{axis}[
			xmin= <>, xmax= <>,
			ymin= <>, ymax = <>,
			axis lines = middle,
		]
			\addplot[domain=<>:<>, samples=<>]{<>};
		\end{axis}
	\end{tikzpicture}
\end{center}]], {
      i(1, "-10"),
      i(2, "10"),
      i(3, "-10"),
      i(4, "10"),
      rep(1),
      rep(2),
      i(5, "100"),
      i(6),
    })
  ),

  -- Surf
  s({ trig = "surf", wordTrig = true },
    fmta([[\begin{center}
	\begin{tikzpicture}
		\begin{axis}[
			view={<>}{<>},
			colormap/viridis, enlarge x limits=true, enlarge y limits=true, enlarge z limits=true,
			domain={<>:<>},
			y domain={<>:<>},
			samples=40, samples y=40,
			xlabel={$x$},
			ylabel={$y$},
			zlabel style={rotate=-90},
			zlabel={$z$},
			title={<>},
			tick label style={font=\tiny, inner sep=0.5pt},
			xtick={<>},
			ytick={<>},
			ztick={<>},
			zmin={<>},
			zmax={<>},
			point meta = z, restrict z to domain*={<>:<>},
		]
			\addplot3[surf, opacity=0.8, shader=interp] {<>};
		\end{axis}
	\end{tikzpicture}
\end{center}]], {
      i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9), i(10), i(11), i(12), rep(11), rep(12), i(13),
    })
  ),

  -- Tikz Node
  s({ trig = "node", wordTrig = true },
    fmta([[\node[<>] (<>) <> {$<>$};<>]], {
      i(5),
      d(1, function(args)
        return sn(nil, {
          f(function(inner_args) return (inner_args[1][1] or ""):gsub("[^%w]", "") end, { 1 }),
          i(1),
        })
      end, { 1 }),
      i(2, "at (0,0) "),
      i(1),
      i(0),
    })
  ),
}
