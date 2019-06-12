require "./index.scss"
import {throttle} from "underscore"
ON_GRID = 0
ON_ANIMATING_TO_VERTICAL = 1
ON_VERTICAL = 2
ON_ANIMATING_TO_GRID = 3

MATRIX_GRID= [
  [ 0,  0], [ 0,  1], [ 1,  1]
  [ 1,  0], [ 1, -1], [ 0, -1]
  [-1, -1], [-1,  0], [-1,  1]
]

SIZE= 10
MARGIN= 5
CIRCLE_BEZIER= (4 / 3) * Math.tan(Math.PI / 8)
CUBE_BEZIER= (8 / 3) * Math.tan(Math.PI / 8)
PATH= (c)->"""
  m 1 0
  c #{c} 0 1 #{1 - c} 1 1
  s #{c - 1} 1 -1 1
  s -1 #{c - 1} -1 -1
  s #{1 - c} -1 1 -1
"""

new Vue
  el: "#root"
  data:
    container: w: 0, h: 0
    header: h: 0
    positions: [0, 0, 0, 0, 0, 0, 0, 0, 0]
  computed:
    resizer: -> throttle @calcLayout, 100
  methods:
    verticalPoints: (index)->
      x: @container.w / 2 - SIZE / 2 - (SIZE + MARGIN)
      y: @container.h - (SIZE + MARGIN) * index
    gridPoints: (index)->
      x: @container.w / 2 - SIZE / 2 + (SIZE + MARGIN) * MATRIX_GRID[index][0]
      y: @header.h / 2 - SIZE / 2 + (SIZE + MARGIN) * MATRIX_GRID[index][1]

    calcLayout: ->
      aside= @$el.querySelector("aside").getBoundingClientRect()
      header= @$el.querySelector("header").getBoundingClientRect()
      @container.w= aside.width; @container.h= aside.height
      @header.h= header.height
    onClickGrid: ->
      @positions.splice i, 1, ON_ANIMATING_TO_VERTICAL for noop, i in @positions

  mounted: ->
    @calcLayout()
    window.addEventListener "resize", @resizer
  render: (h)->
    <div id="root">
      <header><span>header</span></header>
      <aside>
        <svg class="container" viewBox={"0 0 #{@container.w} #{@container.h}"} >
          {nine=[0, 0, 0, 0, 0, 0, 0, 0, 0]}
          {for noop, index in nine
            <g class="drop">
              <path
                id={"mpath-#{index}"}
                stroke-width=".25" stroke="red"
                d={"
                  M #{@gridPoints(index).x} #{@gridPoints(index).y}
                  #{if false then 'ここにそれぞれのモーションパスが入る' else ''}
                  L #{@verticalPoints(index).x} #{@verticalPoints(index).y}
                "}
              ></path>
              <g>
                <svg viewBox="0 0 2 2" width={SIZE} height={SIZE}>
                  <path d={PATH(CUBE_BEZIER)}>
                  </path>
                </svg>
                <animateMotion dur="1s" begin="beginEvent">
                  <mpath href={"#mpath-#{index}"} />
                </animateMotion>
              </g>
            </g>
          }

          {for noop, index in nine
            <g onClick={@onClickGrid} transform={"translate(#{@gridPoints(index).x} #{@gridPoints(index).y})"}>
              <svg-cube />
            </g>
          }
          {for noop, index in nine
            <g transform={"translate(#{@verticalPoints(index).x} #{@verticalPoints(index).y})"}>
              <svg-circle />
            </g>
          }
        </svg>
      </aside>
    </div>
  components:
    SvgCube: render: (h)->
      <svg viewBox="0 0 2 2" width={SIZE} height={SIZE}>
        <path d={PATH(CUBE_BEZIER)}>
          {@$slots.default}
        </path>
      </svg>
    SvgCircle: render: (h)->
      <svg viewBox="0 0 2 2" width={SIZE} height={SIZE}>
        <path d={PATH(CIRCLE_BEZIER)}>
          {@$slots.default}
        </path>
      </svg>
