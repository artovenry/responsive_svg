circle_bezier= (4 / 3) * Math.tan(Math.PI / 8)
cube_bezier= (10 / 3) * Math.tan(Math.PI / 8)
path= (c)->"""
  m 1 0
  c #{c} 0 1 #{1 - c} 1 1
  s #{c - 1} 1 -1 1
  s -1 #{c - 1} -1 -1
  s #{1 - c} -1 1 -1
"""
dropWidth= 10
export default
  circle: path(circle_bezier)
  cube: path(cube_bezier)
  dropWidth: dropWidth
  dropRadius: dropWidth / 2
  grid:
    figure: "cube"
    margin: 5
    drops: [
      [ 0,  0], [ 0,  1], [ 1,  1]
      [ 1,  0], [ 1, -1], [ 0, -1]
      [-1, -1], [-1,  0], [-1,  1]
    ]

  vertical:
    figure: "circle"
    margin: 10
