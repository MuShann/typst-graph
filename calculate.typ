// Set number precision
#let precise(data, prec: 5) = {
  if type(data) == "angle" {return data/180deg*calc.pi}
  let prec = calc.pow(10, prec)
  data = calc.round(data*prec)/prec
  if data < calc.round(1.63312395319537*prec)/prec*calc.pow(10, 16) {return data}
  else {return calc.inf}
}

// Calculate function dictionary
#let calc_cases = (
  "sin": calc.sin,
  "cos": calc.cos,
  "tan": calc.tan,
  "ln": calc.ln,
  "lg": calc.log,
  "arcsin": calc.asin,
  "arccos": calc.acos,
  "arctan": calc.atan,
)

// Operators set
#let opers = ([+], [−], [∗], [⋅], [×], [ ])

// Calculate partial expressions
#let parse_calc_part(parse, math, var, val) = {
  if type(math) == "array" {
    let now_oper = math.at(0)
    let now_val = (parse.calc_math)(parse, math.at(1), var, val)
    if now_oper.has("text") {
      return precise((calc_cases.at(now_oper.text))(now_val))
    }
    else {
      return precise(calc.log(now_val, base: float(now_oper.b.text)))
    }
  }
  else if math.has("t") {
    let base = (parse.calc_math)(parse, math.base, var, val)
    let index = (parse.calc_math)(parse, math.t, var, val)
    return precise(calc.pow(base, index))
  }
  else if math.has("denom") {
    let num = (parse.calc_math)(parse, math.num, var, val)
    let denom = (parse.calc_math)(parse, math.denom, var, val)
    return precise(num/denom)
  }
  else if math.has("radicand") {
    let radicand = (parse.calc_math)(parse, math.radicand, var, val)
    if math.has("index") {
      let index = (parse.calc_math)(parse, math.index, var, val)
      return precise(calc.pow(radicand, 1/index))
    }
    else {return precise(calc.sqrt(radicand))}
  }
  else if math == [e] {
    return calc.e
  }
  else if math == [#var] {
    return val
  }
  else if math.has("text") {
    return int(math.text)
  }
}

// Calculate expression
#let parse_calc_math(parse, math, var, val) = {
  if math.has("body") and math.body.has("children") or math.has("children") {
    let children = none
    if math.has("children") {children = math.children}
    else {children = math.body.children}
    children = children.filter(x => x!=[(] and x!=[)])
    
    let len = children.len()
    let part_str = ()

    for index in range(len) {
      if children.at(index) in opers {continue}
      if children.at(index).has("limits") or children.at(index).has("b") {
        let next = none
        for j in range(index+1, len) {
          if children.at(j) == [ ] {continue}
          next = children.at(j)
          children.at(j) = [ ]
          break
        }
        part_str.push(str((parse.calc_part)(parse, (children.at(index), next), var, val)))
      }
      else {part_str.push(str((parse.calc_math)(parse, children.at(index), var, val)))}
    }
    for (index, child) in children.filter(x => x != [ ]).enumerate() {
      if child == [+] {part_str.insert(index, "+")}
      else if child == [−] {part_str.insert(index, "-")}
      else if child == [∗] or child == [⋅] or child == [×] {part_str.insert(index, "*")}
    }
    return eval(part_str.join())
  }
  else if math.has("body") {
    return (parse.calc_part)(parse, math.body, var, val)
  }
  else {
    return (parse.calc_part)(parse, math, var, val)
  }
}

// Process tool
#let parse = (
  calc_part: parse_calc_part,
  calc_math: parse_calc_math
)

// Calculation program entry
#let calc_math(math, var, val) = {
  parse_calc_math(parse, math, var, val)
}
