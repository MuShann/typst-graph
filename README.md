# typst-graph
A typst package of drawing functions.

## Simple graph
```
#d(-5, -5, grid: 0.5, fill: blue)[
  #l(0, -5, 0, 5, stroke: blue+1pt, larr: 2, dir: top)[#text(fill: blue, size: 0.5em, $y$)]
  #l(-5, 0, 5, 0, stroke: blue+1pt, larr: 2, dir: left)[#text(fill: blue, size: 0.5em, $x$)]
  #f(-5, 5, prec: 10, stroke: red.lighten(20%)+1pt)[$4 dot sin x$]
  #p(calc.pi, 0, orange)[]
]
```
![image](https://github.com/MuShann/typst-graph/assets/73377584/96cb24cc-a6bd-4cff-9fdc-95baf1ad56c3)
