require "./index.scss"
import {throttle} from "underscore"
import {mapState} from "vuex"
import Components from "./Components.coffee"
Vue.use Vuex
new Vue
  el: "#root"
  components: Components
  store: new Vuex.Store
    state:
      animating: off
      resizing: off
      svgWidth: 0, svgHeight:0, headerHeight: 0
      drop: width: 10, margin: 5
    getters:
      origin: (state)->
        begin:
          x: state.svgWidth / 2
          y: state.headerHeight / 2
        end:
          x: (state.svgWidth / 2) - (state.drop.width + state.drop.margin)
          y: state.svgHeight - (state.drop.width / 2  + state.drop.margin)

    mutations:
      begin: (state)->state.animating= on
      init: (state, data)->
        state.svgWidth= data.container.width
        state.svgHeight= data.container.height
        state.headerHeight= data.header.height

  computed: {
    onResizeCb: -> throttle @onInit, 10
  }
  methods:
    calc: ->
      container: @$el.querySelector("aside").getBoundingClientRect()
      header: @$el.querySelector("header").getBoundingClientRect()
    onInit: ->
      @$store.commit "init", @calc()
  mounted: ->
    # setTimeout (=>@onInit()), 0
    @onInit()
    window.addEventListener "resize", @onResizeCb
  render: (h)->
    <div id="root">
      <header><span>header</span></header>
      <aside>
        <svg viewBox={"0 0 #{@$store.state.svgWidth} #{@$store.state.svgHeight}"} >
          <drop index="8" />

        </svg>
      </aside>
    </div>
