require "./index.scss"
import {throttle} from "underscore"
import {mapState,mapGetters} from "vuex"
import Drop from "./Drop.coffee"
import store from "./store"
Vue.use Vuex
new Vue
  el: "#root"
  components: {Drop}
  store: new Vuex.Store store
  computed: {
    onResizeCb: -> throttle @onInit, 10
  }
  methods:
    calc: ->
      container: @$el.querySelector("aside").getBoundingClientRect()
      header: @$el.querySelector("header").getBoundingClientRect()
    onInit: -> @$store.commit "init", @calc()
  mounted: ->
    @onInit()
    window.addEventListener "resize", @onResizeCb
  render: (h)->
    <div id="root">
      <header><span>header</span></header>
      <aside>
        <svg viewBox={"0 0 #{@$store.state.svgWidth} #{@$store.state.svgHeight}"} >
          <drop
            position={
              begin:
            }
          />

          {D= @drop.width + @drop.margin}
          <path id="mpath-8"
            d={"
              M #{@origin.begin.x} #{@origin.begin.y}
              m -#{D} #{D}
              L #{@origin.end.x} #{@origin.end.y}
            "}
            stroke-width="1" stroke="red"
          />

        </svg>
      </aside>
    </div>
