require "./index.scss"
import {throttle} from "underscore"
import Drop from "./Drop.coffee"
import store from "./store.coffee"
import figures from "./figures.coffee"
Vue.use Vuex
new Vue
  el: "#root"
  components: {Drop}
  store: new Vuex.Store store
  computed: onResizeCb: -> throttle @onInit, 10
  methods:
    onInit: -> @$store.commit "init", do =>
      container: @$el.querySelector("aside").getBoundingClientRect()
      header: @$el.querySelector("header").getBoundingClientRect()
  mounted: ->@onInit();window.addEventListener "resize", @onResizeCb
  render: (h)->
    <div id="root">
      <header><span>header</span></header>
      <aside>
        <svg viewBox={"0 0 #{@$store.state.layout.svgWidth} #{@$store.state.layout.svgHeight}"} >
          {for noop, index in [0, 0, 0, 0, 0, 0, 0, 0, 0]
            <path
              id={"mpath-#{index}"}
              stroke-width=".25" stroke="red"
              d={@$store.getters.motionPath(index)}
            ></path>
          }
          {for noop, index in [0, 0, 0, 0, 0, 0, 0, 0, 0]
            <drop index={index}></drop>
          }
        </svg>
      </aside>
    </div>
