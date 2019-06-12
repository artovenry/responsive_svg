import {throttle, compact} from "underscore"
require "./index.scss"
circle_bezier= (4 / 3) * Math.tan(Math.PI / 8)
cube_bezier= (10 / 3) * Math.tan(Math.PI / 8)
path= (c)->"""
  m 1 0
  c #{c} 0 1 #{1 - c} 1 1
  s #{c - 1} 1 -1 1
  s -1 #{c - 1} -1 -1
  s #{1 - c} -1 1 -1
"""

ON_GRID = 0
ON_ANIMATING_TO_VERTICAL = 1
ON_VERTICAL = 2
ON_ANIMATING_TO_GRID = 3

new Vue
  el: "#root"
  data:
    container: w: 0, y: 0
    header: h: 0
    drop: w:0, h: 0
    positions: [0, 0, 0, 0, 0, 0, 0, 0, 0]
  computed:
    origin:->
      x: @container.w / 2 - @drop.w / 2, y: @header.h / 2  - @drop.w / 2
    resizer: -> throttle @calcLayout, 100
  methods:
    calcLayout: ->
      aside= @$el.querySelector("aside").getBoundingClientRect()
      header= @$el.querySelector("header").getBoundingClientRect()
      drop= @$el.querySelector(".drop").getBoundingClientRect()
      @container.w= aside.width; @container.h= aside.height
      @drop.w= drop.width; @drop.h= drop.height
      @header.h= header.height
    onClickIcon: ->
  mounted: ->
    @calcLayout()
    window.addEventListener "resize", @resizer
  components:
    drop:
      props: ["index"]
      computed:
        position:
          get: ->@$parent.positions[@index]
          set: (val)->@$parent.positions.splice @index, 1, val
        class: -> compact([
          "drop"
          "drop-#{@index}"
          switch @position
            when ON_GRID
              "drop-grid"
            when ON_ANIMATING_TO_VERTICAL
              "drop-animating-vertical"
            when ON_VERTICAL
              "drop-vertical"
            when ON_ANIMATING_TO_GRID
              "drop-animating-grid"
        ]).join (" ")
      methods:
        onAnimationend: ->@position= switch @position
          when ON_ANIMATING_TO_VERTICAL then ON_VERTICAL
          when ON_ANIMATING_TO_GRID then ON_GRID
        onClick: -> switch @position
          when ON_GRID
            @$parent.positions.splice i, 1, ON_ANIMATING_TO_VERTICAL for noop, i in @$parent.positions
          when ON_VERTICAL
            #ホントは、ページャーの動きをさせる
            @$parent.positions.splice i, 1, ON_ANIMATING_TO_GRID for noop, i in @$parent.positions

      render: (h)->
        <div
          class={@class}
          onAnimationend={@onAnimationend}
          onClick={@onClick}
        >
          <div class="drop-transform">
            <svg viewBox="0 0 2 2">
              <path d={path(cube_bezier)} />
            </svg>
          </div>
        </div>
    icon:
      render: (h)->
        <svg viewBox="0 0 2 2">
          <path d={path(circle_bezier)} />
        </svg>
  render: (h)->
    <div id="root">
      <header><span>header</span></header>
      <aside>
        <div style={"transform: translate(#{@origin.x}px, #{@origin.y}px)"}>

          {for noop, i in [0,0,0,0,0,0,0,0,0]
            <drop index={i}
            />
          }
        </div>
      </aside>
    </div>
