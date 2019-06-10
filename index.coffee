require "./index.scss"
import {throttle} from "underscore"
new Vue
  el: "#root"
  data: ->
    resizing: off
    width: 0, height:0, headerHeight: 0
  computed:
    onResizeCb: -> throttle @onInit, 10
  methods:
    calc: ->
      container: @$el.querySelector("aside").getBoundingClientRect()
      header: @$el.querySelector("header").getBoundingClientRect()
    onInit: ->
      sizes= @calc()
      [@width, @height, @headerHeight]= [sizes.container.width, sizes.container.height, sizes.header.height]
  mounted: ->
    @onInit()
    window.addEventListener "resize", @onResizeCb
  components: do ->
    CIRCLE= (4 / 3) * Math.tan(Math.PI / 8)
    drop:
      props: ["x", "y"]
      render: (h)->

  render: (h)->
    <div id="root">
      <header>header</header>
      <aside>
        <svg
          viewBox={"0 0 #{@width} #{@height}"}
        >
          <circle cx="30" cy="30" r="4" stroke="none" fill="green"></circle>
          <Drop x="50", y="50"></Drop>
          <path stroke-width="5" stroke="green" d={"m 0 #{@headerHeight} h #{@width}"}></path>
        </svg>
      </aside>
    </div>
