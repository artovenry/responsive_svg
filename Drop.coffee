import figures from "./figures.coffee"
import {mapGetters} from "vuex"

export default
  props: ["index"]
  data: ->
    duration: "1s"
    direction: "vertical"
  computed: {
    position: ->@$store.state.animation.items[@index]
    mapGetters(["onAnimating", "onGrid", "onVertical", "gridDelta", "verticalDelta"])...
  }
  watch: position: (newVal, oldVal)->
    @direction= if oldVal is 0 then "vertical" else "grid"
    @startAnimation() if newVal is 1
  methods:
    onClick: ->unless @onAnimating() then @$store.commit "toggleOn"
    onAnimationEnd: ->if @onAnimating() then @$store.commit "toggleOff", index: @index, direction: @direction
    startAnimation: ->
      @$el.querySelector("animate").beginElement()
      @$el.querySelector("animateMotion").beginElement()

  render: (h)->
    <g transform={
        if @onGrid(@index)
          "translate(#{@gridDelta(@index).dx} #{@gridDelta(@index).dy})"
        else if @onVertical(@index)
          "translate(#{@verticalDelta(@index).dx} #{@verticalDelta(@index).dy})"
      }
    >
      <g transform={"translate(-#{figures.dropRadius} -#{figures.dropRadius})"}>
        <animateMotion
          dur={@duration}
          begin="beginEvent"
          onEndEvent={@onAnimationEnd}
          keyPoints={if @direction is "vertical" then "0;1" else "1;0"}
          keyTimes="0;1"
          calcMode="linear"
        >
          <mpath href={"#mpath-#{@index}"} />
        </animateMotion>

        <svg viewBox="0 0 2 2" width={figures.dropWidth} height={figures.dropWidth} onClick={@onClick}>
          <path d={figures[figures[if @onGrid(@index) then 'grid' else if @onVertical(@index) then 'vertical']?.figure]}>
            <animate attributeName="d"
              dur={@duration}
              begin="beginEvent"
              from={figures[figures[if @direction is "vertical" then "grid" else "vertical"].figure]}
              to={figures[figures[unless @direction is "vertical" then "grid" else "vertical"].figure]}
              calcMode="paced"
            />
          </path>
        </svg>
      </g>
    </g>
