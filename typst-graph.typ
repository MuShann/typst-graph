#import "calculate.typ": *

#let d(..nums, grid: 1, fill: white, stroke: none, clip: false, body) = {
  let area = nums.pos() + (-5, -5, 5, 5).slice(nums.pos().len(), 4)
  let w = (area.at(2) - area.at(0))*10pt
  let h = (area.at(3) - area.at(1))*10pt
  grid *= 10pt

  if stroke == none {stroke = (thickness: 0.25pt, paint: fill.darken(20%))}
  fill = fill.lighten(90%)
  
  box(width: w, height: h, clip: clip,
    {
      rect(fill: fill, width: w, height: h)
      if grid != 0pt {
        place(stack(dir: ltr, ..range(int(w/grid)+1).map(x => place(line(start: (x*grid, 0pt), length: h, angle: -90deg, stroke: stroke)))))
        place(stack(dir: ttb, ..range(int(h/grid)+1).map(x => place(line(start: (0pt, -x*grid), length: w, stroke: stroke)))))
      }
      place(left+bottom, dx: -area.at(0)*10pt, dy: area.at(1)*10pt,
        {for item in body.children {place(item)}}
      )
    }
  )
}

#let f(..nums, prec: 1, stroke: black+0.5pt, name: true, var: "x", func: none, body) = {
  let nums = nums.pos() + (-5, 5, -100, 100).slice(nums.pos().len(), 4)
  let (begin, end, down, up) = nums
  let begin_int = 0
  let end_int = 0
  if begin < 0 {begin_int = int(begin)} else {begin_int =int(begin)+1}
  if end < 0 {end_int = int(end)-1} else {end_int = int(end)}
  
  let lines = ()
  let points = ()
  let flag = false

  let x_range = range(0, int(calc.abs(begin -begin_int)*100)).map(x => begin+x/100)+range(0,(end_int -begin_int)*10*prec+1).map(x => begin_int+x/10/prec)+range(0,int(calc.abs(end -end_int)*100)).map(x => end_int+x/100)
  
  for x in x_range {
    let y = 0
    if func == none {
      y = -calc_math(body, var, x)
    }
    else {
      y = -func(x)
    }
    if -y < up and -y > down {points.push((x*10pt, y*10pt));flag = true}
    else if flag == true {lines.push(points);points = ();flag = false}
    else {flag = false}
  }
  if points.len() != 0 {lines.push(points)}
  for line in lines {place(top, path(stroke: stroke, ..line))}

  if name {
    let last = lines.filter(x => x.len() != 0).last().last()
    place(dx: last.at(0)+2pt, dy: last.at(1)-0.25em,text(size:0.5em, body))
  }
}

#let p(x, y, color, radius: 1.2pt, solid: true, dir: left, body) = {
  place(dx:x*10pt-radius, dy: -y*10pt-radius)[
    #if solid {circle(radius: radius, fill: color)}
    else {circle(radius: radius, stroke: 0.75pt+color)}
  ]
  let align = none
  if dir == left {align = left+horizon}
  else if dir == right {align = right+horizon}
  else if dir == top {align = center+bottom}
  else if dir == bottom {align = center+top}
  place(dx: x*10pt, dy: -y*10pt, box(width: 0pt, height: 0pt, inset: 2pt, place(align, body)))
}

#let l(..nums, stroke: 1pt, larr: 0, rarr: 0, dir: left, body) = {
  let (x0, y0, x1, y1) = nums.pos() + (0, 0, 5, 5).slice(nums.pos().len(), 4)
  
  let angle = 0deg
  if x0 == x1 {angle = -90deg}
  else {angle = calc.atan((y0 - y1)/(x1 - x0))}
  if x0 > x1 or ((not x0 < x1) and y0 > y1) {angle += 180deg}
  let len = calc.sqrt(calc.pow((x0 -x1),2)+calc.pow((y0 -y1),2))

  set path(stroke: stroke)
  place(path((x0*10pt, -y0*10pt), (x1*10pt, -y1*10pt)))
  if larr != 0 {
    place(
      dx: x1*10pt, dy: -y1*10pt,
      rotate(
        angle,
        box(width: 0pt, height: 0pt,
          place(center+horizon, dy: larr*0.5pt,
            path((-larr*2pt, larr*1pt), (0pt, 0pt), (-larr*2pt, -larr*1pt))
          )
        )
      )
    )
  }
  if rarr != 0 {
    place(
      dx: x0*10pt, dy: -y0*10pt,
      rotate(
        angle,
        box(width: 0pt, height: 0pt,
          place(center+horizon, dx: rarr*1pt, dy: rarr*0.5pt,
            path((rarr*2pt, rarr*1pt), (0pt, 0pt), (rarr*2pt, -rarr*1pt))
          )
        )
      )
    )
  }

  set text(baseline: -0.125em)
  let align = none
  if dir == left {align = left+horizon}
  else if dir == right {align = right+horizon}
  else if dir == top {align = center+bottom}
  else if dir == bottom {align = center+top}
  place(dx: x1*10pt, dy: -y1*10pt, box(width: 0pt, height: 0pt, inset: 2pt, place(align,body)))
}
