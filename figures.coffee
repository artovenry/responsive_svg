CIRCLE= (4 / 3) * Math.tan(Math.PI / 8)
CUBE= (10 / 3) * Math.tan(Math.PI / 8)

drop= (c)->"""
  m 1 0
  c #{c} 0 1 #{1 - c} 1 1
  s #{c - 1} 1 -1 1
  s -1 #{c - 1} -1 -1
  s #{1 - c} -1 1 -1
"""

beginPosition=[
    [0, 0]
    [0, -1]
    [0, 0]
    [0, 0]
    [0, 0]
    [0, 0]
    [0, 0]
    [0, 0]
    [0, 0]
]
